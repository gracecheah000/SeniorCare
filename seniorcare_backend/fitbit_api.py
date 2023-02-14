from flask import Blueprint
import fitbit
from fitbit import gather_keys_oauth2 as Oauth2
import pandas as pd
import datetime 
from dotenv import load_dotenv
import os
    
load_dotenv()

fitbitBlueprint = Blueprint('fitbit_blueprint', __name__)

CLIENT_ID = os.environ.get("FITBIT_CLIENT_ID")
CLIENT_SECRET = os.environ.get("FITBIT_CLIENT_SECRET")


server = Oauth2.OAuth2Server(CLIENT_ID, CLIENT_SECRET)
server.browser_authorize()


ACCESS_TOKEN = str(server.fitbit.client.session.token['access_token'])  # type:ignore
REFRESH_TOKEN = str(server.fitbit.client.session.token['refresh_token']) # type:ignore

auth2_client = fitbit.Fitbit(CLIENT_ID, CLIENT_SECRET, oauth = True, access_token= ACCESS_TOKEN, refresh_token= REFRESH_TOKEN)

@fitbitBlueprint.route('/steps/<date>', methods = ['GET']) #type:ignore
def getSteps(date):
    steps = auth2_client.intraday_time_series('activities/steps', base_date=date, detail_level='15min')
    return steps

@fitbitBlueprint.route('/heart/<date>', methods = ['GET']) #type:ignore
def getHeart(date):
    heart = auth2_client.intraday_time_series('activities/heart', base_date=date, detail_level='15min')
    return heart
