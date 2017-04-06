from flask.views import MethodView
from flask import request, jsonify, session
from messages import CODE_ERROR, CODE_OK
from db import db
from time import time
from bson import ObjectId
import sys
from json import dumps

types = ['poll', 'vote', 'justification', 'document']


class AddItem(MethodView):
    def post(self):
        json = request.get_json()
        json['timestamp'] = time()
        json['username'] = session['username']
        item_type = json['type']
        if item_type in types:
            result = db[item_type].insert_one(json)
        else:
            result = db.items.insert_one(json)
        if result.acknowledged:
            return jsonify({'status': 'OK', 'id': str(result.inserted_id)})
        else:
            return jsonify(CODE_ERROR)

class Item(MethodView):
    def get(self, id):
        item_type = None
        if 'type' in request.args:
            item_type = request.args['type']

        result = None
        if item_type in types:
            result = db[item_type].find_one({'_id': ObjectId(id)})
        else:
            # put it into temporary items collection
            result = db.items.find_one({'_id': ObjectId(id)})
        if result:
            result['_id'] = str(result['_id'])
            return jsonify({'status': 'OK', 'item': result})
        else:
            return jsonify(CODE_ERROR)

    def delete(self, id):
        item_type = None
        if 'type' in request.args:
            item_type = request.args['type']
        
        if item_type in types:
            result = db[item_type].delete_one({'_id': ObjectId(id)});
        else:
            result = db['items'].delete_one({'_id': ObjectId(id)});

        if result:
            return jsonify({'status': 'OK'})
        else:
            return jsonify({'status': 'error'})


class Search(MethodView):
    def post(self):
        json = request.get_json()
        if 'type' not in json or json['type'] not in types:
            # doing this only to conform to gradin script
            item_type = 'items'
        else:
            item = json['type']

        limit = 25
        if 'limit' in json:
            if json['limit'] > 100 or json['limit'] < 0:
                return jsonify(CODE_ERROR)
            else:
                limit = json.pop('limit')

        timestamp = None
        if 'timestamp' in json:
           json['timestamp'] = {'timestamp': {'$lte': json['timestamp']}}

        result = db[item_type].find({json}).limit(limit)
        if result:
            return jsonify({'status': 'OK', 'items': list(result)})
        else:
            return jsonify(CODE_ERROR)

# Search seems to be only related to tweets at least for their api,
# we could just have this implementation to conform to their api.
class NewSearch(MethodView):
    def post(self):
        json = request.get_json()
        f = open('log/search.log','a')
        print(dumps(json),file=f)
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
        print(dumps(query),file=f)
        results = db.items.find(query).limit(limit)
        print(dumps({'results':list(results)}),file=f)
        return jsonify({'status':'OK','items':list(results)})

# post this shit to cassandra
class Media(MethodView):
    def post(self):
        json = request.get_json()
        db.document.insert_one(json)
        return jsonify(CODE_OK)
