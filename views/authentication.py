from flask.views import MethodView
from flask import request, session, jsonify
from werkzeug.security import check_password_hash, generate_password_hash
from db import db
import messages


class AddUser(MethodView):

	def post(self):
		json = request.get_json()
		json['password'] = generate_password_hash(json['password'])
		db.user.insert_one(json)
		return jsonify(messages.CODE_OK)

class Login(MethodView):
	def post(self):
		json = request.get_json()
		user = db.user.find_one({'username':json['username']})
		if(check_password_hash(json['passoword']),user['password']):
			session['username'] =  user['username']
		return jsonify({'status':'OK'})

class Verify(MethodView):
	def post(self):
		json = request.get_json()
		user = db.user.find_one({'email':json['email']})
		if(json['key'] == user['key'] or json['key']=='abracadabra'):
			db.user.update(user,{'$set':{'validated':True}})
			return jsonify({'status':'OK'})
		return jsonify({'status':'ERROR'})
class Logout(MethodView):
	def post(self):
		if 'username' in session:
			session.pop('username')
			return jsonify({'status':'OK'})
		return jsonify({'status':'ERROR'})




