from flask import Blueprint, request
from firebase_admin import firestore, get_app

get_app()

db = firestore.client()
healthData_ref = db.collection('healthData')

healthBlueprint = Blueprint('health_metrics_blueprint', __name__)

@healthBlueprint.route('/step', methods = ['GET']) #type: ignore
def getDailyStep():
    try:
        # need user id + date in parameters
        user_id = request.args.get('id')
        date = request.args.get('date')
        if user_id: 
            health_data = healthData_ref.document(user_id).get()
            return str((health_data.to_dict())['steps'][date])
    
    except Exception as e:
        return f"An Error Occured: {e}"
    
@healthBlueprint.route('/heart_rate', methods = ['GET']) #type: ignore
def getAverageDailyHeartRate():
    try:
        user_id = request.args.get('id')
        date = request.args.get('date')
        if user_id: 
            health_data = healthData_ref.document(user_id).get()
            heart_rate_data = health_data.to_dict()['heart rate']
            filtered_heart_rate = {k:v for (k,v) in heart_rate_data.items() if date in k}
            sum_heart_rate = sum(filtered_heart_rate.values())
            if (sum_heart_rate != 0):
                average_heart_rate = sum_heart_rate/len(filtered_heart_rate)
                return str(int(average_heart_rate))
            else: return str(0)
    
    except Exception as e:
        return f"An Error Occured: {e}"