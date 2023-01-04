from flask import Flask
from authentication import authentication_blueprint
from firebase_admin import credentials, initialize_app

app = Flask(__name__)

cred = credentials.Certificate('serviceAccountKey.json')
default_app = initialize_app(cred)

# Blueprints to other functions of the application
app.register_blueprint(authentication_blueprint)

if __name__ == "__main__":
    app.run()