
import firebase_admin
from firebase_admin import credentials, messaging
from flask import Blueprint, request
import os
import json
from dotenv import load_dotenv
    
load_dotenv()

if (os.environ.get("IS_APP_ENGINE")):
    cred = credentials.Certificate("serviceAccountKey.json")
else:
    cred = credentials.Certificate(json.loads(os.environ["FIREBASE_CREDENTIALS"]))
firebase_admin.initialize_app(cred)

messageBlueprint = Blueprint('message_blueprint', __name__)

@messageBlueprint.route('/medication/<registrationToken>', methods = ['POST'])
def sendMedicationPush(registrationToken):
    message = messaging.Message(
        notification = messaging.Notification(
        title = 'New Medication Added', body = 'You have a new medication added. Click to view'
        ),
        data = request.json, 
        token = registrationToken
    )

    response = messaging.send(message)
    return response

@messageBlueprint.route('/medication/delete/<registrationToken>', methods = ['POST'])
def deleteNotification(registrationToken):
    message = messaging.Message(
        notification = messaging.Notification(
        title = 'Medication Deleted', body = 'A medication has been deleted. Click to view.'
        ),
        data = request.json, 
        token = registrationToken
    )
    response = messaging.send(message)
    return response

@messageBlueprint.route('/appointment/<registrationToken>', methods = ['POST'])
def sendNotificationPush(registrationToken):
    message = messaging.Message(
        notification = messaging.Notification(
        title = 'New Appointment Added', body = 'You have a new appointment added. Click to view'
        ),
        data = request.json, 
        token = registrationToken
    )

    response = messaging.send(message)
    return response

@messageBlueprint.route('/appointment/delete/<registrationToken>', methods = ['POST'])
def deleteAppointmentNotification(registrationToken):
    message = messaging.Message(
        notification = messaging.Notification(
        title = 'Appointment Deleted', body = 'An appointment has been deleted. Click to view.'
        ),
        data = request.json, 
        token = registrationToken
    )
    response = messaging.send(message)
    return response