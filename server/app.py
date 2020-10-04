from flask import Flask
from flask_restful import Api
from ressources.repository import Repository
from ressources.download import Download


DOWNLOAD_DIR = 'downloads\\'


app = Flask(__name__)
api = Api(app)

app.config['DOWNLOAD_DIR'] = DOWNLOAD_DIR

api.add_resource(Repository, '/api/<string:index>')
api.add_resource(Download, '/api/download/<path:filename>')


@app.route('/')
def running():
    return 'We are online.'


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
