
import firebase_admin
from firebase_admin import credentials, messaging
from flask import Blueprint

cred = credentials.Certificate("seniorcare_backend/serviceAccountKey.json")
firebase_admin.initialize_app(cred)

messageBlueprint = Blueprint('message_blueprint', __name__)

@messageBlueprint.route('/', methods = ['GET'])
def check():
    return 'Notification Page'

@messageBlueprint.route('/<string: =registrationToken>')
def sendPush(title, msg, registrationToken, dataObject):
    message = messaging.Message(
        notification = messaging.Notification(
        title = title, body = msg
        ),
        data = dataObject, 
        token = registrationToken
    )

    response = messaging.send(message)
    print(response.status_code)
    print('Successfully sent message:', response)
    return response
