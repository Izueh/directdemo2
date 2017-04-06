from flask.views import MethodView
from flask import request, session, jsonify
from werkzeug.security import check_password_hash, generate_password_hash
from db import db
import messages


class AddUser(MethodView):

	def post(self):
		json = request.get_json()
		json['password'] = generate_password_hash(json['password'])
        try: 
            db.user.insert_one(json)
        except: 
            return jsonify({'status':'error','error':'user already exists'})
		return jsonify(messages.CODE_OK)

class Login(MethodView):
	def post(self):
		json = request.get_json()
		user = db.user.find_one({'username':json['username']})
        f = open('log','w')
        f.write("username {0}, password {1}".format(json['username'],json['password']))

		if(check_password_hash(json['password'],user['password'])):
			session['username'] =  user['username']
		else:
			return jsonify({'status':'ERROR','error':'failed to authenticate'})	
		return jsonify({'status':'OK'})

class Verify(MethodView):
	def post(self):
		json = request.get_json()
		user = db.user.find_one({'email':json['email']})
		if(json['key']=='abracadabra'):
			db.user.update(user,{'$set':{'validated':True}})
			return jsonify({'status':'OK'})
		return jsonify({'status':'ERROR'})
class Logout(MethodView):
	def post(self):
		if 'username' in session:
			session.pop('username')
			return jsonify({'status':'OK'})
		return jsonify({'status':'ERROR'})




