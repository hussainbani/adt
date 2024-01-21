import json
from healthcheck import HealthCheck
from flask import current_app as app

health = HealthCheck()


def check_application_status():
    return health.run()


class Adjustapi:

    def hello_world(self):
        return {"message": "Hello World"}

    def health_check(self):
        status = check_application_status()
        app_info = json.loads(status[0])
        if status[1] == 200:
            return {"application": app.name, "status": "success",
                    "hostname": app_info["hostname"],
                    "timestamp": app_info["timestamp"],
                    "result": app_info["results"]}
        else:
            raise ("Error occured, check the application. Error: {}".format(
                    app_info['results']))
