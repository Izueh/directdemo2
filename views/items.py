from flask.views import MethodView
from flask import request, jsonify
import messages
from db import db
from datetime import datetime

types = ['poll','vote','justification','document']

class AddItem(MethodView):
	def post(self):
		json = request.get_json()
		json['timestamp']= datetime.utcnow()
		item_type = json['type']
		if item_type in types:
			result = db[item_type].insert_one(json)
		else:
			return jsonify(CODE_ERROR)
		if result['acknowledged']:
			return jsonify({'status':'OK', 'id': str(result[insertedID])})
		else:
			return jsonify(CODE_ERROR)

class Item(MethodView):
	def get(self,id):
		item_type = request.args['type']
		result = None
		if item_type not in types:
			return jsonify(CODE_ERROR)
		result = db[item_type].find_one({'id':id})
		if result:
			return jsonify({'status':'OK', 'item':result})
		else:
			return jsonify(CODE_ERROR)


class Search(MethodView):
	def post(self):
		json = request.get_json()
		item_type = json['type']
		limit = 25
		timestamp  = None
		if 'limit' in json:
			if json['limit'] > 100:
				return jsonify(CODE_ERROR)
			else:
				limit = json.pop['limit']
		if item_type not in types:
			return jsonify(CODE_ERROR)
		if 'timestamp' in json:
			json['timestamp'] = {'timestamp': {'$gt': json['timestamp']}}

		result = db[item_type].find({json}).limit(limit)
		if result:
			return jsonify({'status':'OK','items':list(result)})
		else:
			return jsonify(CODE_ERROR)

class Media(MethodView):
	def post(self):
		json = request.get_json()
		db.document.insert_one(json)
		return jsonify(CODE_OK)
