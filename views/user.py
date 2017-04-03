from flask import MethodView, jsonify, request, session
from db import db
import messages

class User(MethodView):
    def get(self, username):
        user = db.user.get({'username':username})
        return jsonify(user)


class Follow(MethodView):
    def post(self):
        json = request.get_json()
        follow = True
        if 'follow' in json:
            follow = json.pop('follow')
        if follow:
            db.user.update_one({'username':session['username']},{ '$push':{'followers':json['username']}})
            db.user.update_one({'username':json['username']},{'&push':{'followers':session['username']}})
        else:
            db.user.update_one({'username':session['username']},{ '$pull':{'followers':json['username']}})
            db.user.update_one({'username':json['username']},{'&pull':{'followers':session['username']}})

        return jsonify(CODE_OK)
