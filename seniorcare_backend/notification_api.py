
from firebase_admin import messaging, get_app
from flask import Blueprint, request

get_app()

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

@messageBlueprint.route('/medication/update/<registrationToken>', methods = ['POST'])
def updateNotification(registrationToken):
     message = messaging.Message(notification=messaging.Notification(
         title='Medication Timings Updated', body = "Click to update medication reminders"),
         data = request.json, token = registrationToken
     )

     response = messaging.send(message)
     return response

@messageBlueprint.route('/medication/delete/<registrationToken>', methods = ['POST'])
def deleteNotification(registrationToken):
    message = messaging.Message(
        notification = messaging.Notification(
        title = 'Medication Deleted', body = 'A medication has been deleted. Click to view.'),
        data = request.json, token = registrationToken
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
        notification = messaging.AndroidNotification(
        title = 'Appointment Deleted', body = 'An appointment has been deleted. Click to view.', click_action= "FLUTTER_NOTIFICATION_CLICK", priority="max"
        ),  
        data = request.json, 
        token = registrationToken
    )
    response = messaging.send(message)
    return response

@messageBlueprint.route('/sos/<registrationToken>', methods = ['POST'])
def sendSOSPush(registrationToken):
    request_data = request.json
    message = messaging.Message(
        android= messaging.AndroidConfig(priority="high"),
        notification = messaging.Notification(
            title = 'SOS Request', body = 'You have a SOS call from ' + request_data['name']), # type: ignore
            data = request_data,
            token = registrationToken
        )
    response = messaging.send(message)
    return response