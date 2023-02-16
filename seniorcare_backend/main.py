from flask import Flask
from notification_api import messageBlueprint

app = Flask(__name__)
app.register_blueprint(messageBlueprint, url_prefix = '/notification')

@app.route('/')
def index():
    return 'Home'

if __name__ == "__main__":
    app.run(port=8080)