from flask.views import MethodView
from flask import request, jsonify
import messages
from db import db
from time import time

types = ['poll', 'vote', 'justification', 'document']


class AddItem(MethodView):
    def post(self):
        json = request.get_json()
        json['timestamp'] = time()
        item_type = json['type']
        if item_type in types:
            result = db[item_type].insert_one(json)
        else:
            result = db.items.insert_one(json)
        if result.acknowledged:
            return jsonify({'status': 'OK', 'id': str(result.insertedID)})
        else:
            return jsonify(CODE_ERROR)

class Item(MethodView):
    def get(self, id):
        item_type = None
        if 'type' in request.args:
            item_type = request.args['type']

        result = None
        if item_type in types:
            result = db[item_type].find_one({'id': id})
        else:
            # put it into temporary items collection
            restult = db.items.find_one({'id': id})
        if result:
            return jsonify({'status': 'OK', 'item': result})
        else:
            return jsonify(CODE_ERROR)

    def delete(self, id):
        item_type = None
        if 'type' in request.args:
            item_type = request.args['type']
        
        if item_type in types:
            result = db[item_type].delete_one({'id': id});
        else:
            result = db['items'].delete_one({'id': id});

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

# post this shit to cassandra
class Media(MethodView):
    def post(self):
        json = request.get_json()
        db.document.insert_one(json)
        return jsonify(CODE_OK)
