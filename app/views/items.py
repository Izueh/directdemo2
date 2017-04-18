from flask.views import MethodView
from flask import request,jsonify,session, Response
from messages import CODE_ERROR, CODE_OK, NOT_LOGGED_IN
from db import db, cassandra
from time import time
from bson import ObjectId
import sys
from bson.json_util import dumps

class AddItem(MethodView):
    def post(self):
        json = request.get_json()
        json['timestamp'] = time()
        json['username'] = session['username']
        result = db.items.insert_one(json)
        if result.acknowledged:
            if 'parent' in json:
                db.items.update_one({'_id':ObjectId(json['parent'])},{'replies':{'$push':json}})
            return jsonify({'status': 'OK', 'id': str(result.inserted_id)})
        else:
            return jsonify(CODE_ERROR)

class Item(MethodView):
    def get(self, id):
        result = db.items.find_one({'_id': ObjectId(id)})
        if result:
            result['_id'] = str(result['_id'])
            return jsonify({'status': 'OK', 'item': result})
        else:
            return jsonify(CODE_ERROR)

    def delete(self, id):
        result = db['items'].delete_one({'_id': ObjectId(id)});
        # delete medias in cassandra
        if result:
            return jsonify({'status': 'OK'})
        else:
            return jsonify({'status': 'error'})

    def post(self, id):
        json = request.get_json()
        tweet = db.items.find_one({'_id':ObjectId(id)})
        if json['like']:
            if session['username'] in tweet['likes']:
                return jsonify({'status': 'error','error':'user already likes this tweet'})
            tweet['likes'].append(session['username'])
        else:
            if session['username'] in tweet['likes']:
                tweet['likes'].pop(session['username'])
            else:
                return jsonify({'status':'error','error':'user has not liked this'})
        db.replace_one({'_id':tweet['_id']}, tweet)
        return jsonify({'status': 'OK'})

# Search seems to be only related to tweets at least for their api,
# we could just have this implementation to conform to their api.
class Search(MethodView):
    def post(self):
        json = request.get_json()
        f = open('log/search.txt','a')
        username = json.pop('username') if 'username' in json else None
        following = True
        if 'following' in json:
            following = json.pop('following')
        else:
            if username:
                following = True
        timestamp = json.pop('timestamp') if 'timestamp' in json else time()
        search = 'q' in json
        limit = json.pop('limit') if 'limit' in json and json['limit'] <= 100 else 50
        following_list = db.user.find_one({'username':session['username']})['following']
        query = {'timestamp':{'$lte':timestamp}}
        if search:
            query['$text'] = {'$search':json['q']}
        if username:
            if following:
                query['username'] = username if username in following_list else ''
            else:
                query['username'] = username
                
        else:
            if following:
                query['username'] = {'$in': following_list}
        results = db.items.aggregate([{'$match':query}, {'$addFields':{'id':'$_id'}}, {'$limit': limit}])
        return Response(response = dumps({'status':'OK','items':list(results)}),mimetype='application/json')

class Media(MethodView):
    def post(self):
        f = request.files['content']

        rows = cassandra.execute(
            "INSERT INTO media (id, contents, filename, mimetype) VALUES (%s,%s,%s,%s)", 
            (uuid.uuid1(), f.stream.read(), f.name(), f.mimetype)
        )

        if not rows:
            return jsonify({'status': 'error'})
        else:
            return jsonify({'status': 'OK'})
