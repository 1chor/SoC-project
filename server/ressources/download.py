from flask_restful import Resource
from flask import current_app
import flask
import os


class Download(Resource):
    def get(self, filename):
        if filename is None:
            return 404
        import app
        filepath = os.path.join(current_app.root_path, app.app.config['DOWNLOAD_DIR'])
        if os.path.isfile(os.path.join(filepath,filename)):
            return flask.send_from_directory(filepath,filename)
        else:
            return 404
