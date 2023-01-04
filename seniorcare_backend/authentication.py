from flask import Blueprint

authentication_blueprint = Blueprint('authentication_blueprint', __name__)

@authentication_blueprint.route('/user', methods = ['GET'])
def register_elderly():
    return 