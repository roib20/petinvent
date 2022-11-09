from flask import Blueprint, make_response

view = Blueprint(__name__, "view")


@view.route("/health", methods=['GET'])
def health():
    """
    GET /health
    - By default returns "OK" and status 200 OK
    """
    data1 = {'message': ' OK ',
             'status code:': ' 200 OK '}
    return make_response(data1, 200)
