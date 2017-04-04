from flask import Flask, request, session
from pymongo import MongoClient
from views.authentication import AddUser, Login, Logout, Verify
from views.items import AddItem, Search, Item, Media
import messages

app = Flask(__name__)

app.add_url_rule('/adduser', view_func=AddUser.as_view('adduser'),methods=['POST'])
app.add_url_rule('/user/<username>', view_func=User.as_view('user'),methods=['GET', 'POST'])

app.add_url_rule('/login', view_func=Login.as_view('login'),methods=['POST'])
app.add_url_rule('/verify', view_func=Verify.as_view('verify'),methods=['POST'])
app.add_url_rule('/logout', view_func=Logout.as_view('logout'),methods=['POST'])

app.add_url_rule('/additem',view_func=AddItem.as_view('additem'),methods=['POST'])
app.add_url_rule('/item/<id>', view_func=Item.as_view('item'))
app.add_url_rule('/search', view_func=Search.as_view('search'),methods=['POST'])
app.add_url_rule('/media', view_func=Media.as_view('media'),methods=['POST'])


if __name__ == '__main__':
	app.config['DEBUG']=True
	app.run()




