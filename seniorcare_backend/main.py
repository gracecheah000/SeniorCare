from flask import Flask
import os
from firebase_admin import credentials, initialize_app
import json
from dotenv import load_dotenv
    
load_dotenv()

if (os.environ.get("IS_APP_ENGINE")):
    cred = credentials.Certificate("serviceAccountKey.json")
else:
    cred = credentials.Certificate(json.loads(os.environ["FIREBASE_CREDENTIALS"]))

default_app = initialize_app(cred)

from notification_api import messageBlueprint
from health_metrics_api import healthBlueprint

app = Flask(__name__)
app.register_blueprint(messageBlueprint, url_prefix = '/notification')
app.register_blueprint(healthBlueprint, url_prefix = '/health_metrics')

@app.route('/')
def index():
    return 'Home'

if __name__ == "__main__":
    app.run(port=8080)