from flask import Flask, request, jsonify
from functools import wraps
from api.adjust import Adjustapi


def token_required(valid_token):
    def _token_required(f):
        @wraps(f)
        def decorator(*args, **kwargs):
            token = None
            if "X-Auth-Token" in request.headers:
                token = request.headers["X-Auth-Token"]
            if not token or token != valid_token:
                return {"error": "Invalid auth token"}, 403

            return f(*args, **kwargs)
        return decorator
    return _token_required


def create_app(token=""):
    valid_token = "T1&eWbYXNWG1w1^YGKDPxAWJ@^et^&kX"
    testapi = Adjustapi()
    if token != "":
        valid_token = token
    app = Flask(__name__)

    @app.route("/ping")
    def ping():
        return "OK"

    @app.route("/app")
    @token_required(valid_token)
    def hello_world():
        try:
            return jsonify(testapi.hello_world()), 200
        except Exception as e:
            return jsonify({"status": "error", "message": e}), 500

    @app.route("/health")
    def health_check():
        try:
            return jsonify(testapi.health_check()), 200
        except Exception as e:
            return jsonify({"status": "error", "message": e}), 500

    return app
