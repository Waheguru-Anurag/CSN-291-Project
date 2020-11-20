from main import main
import base64
import flask
from PIL import Image
from flask import Flask, request, jsonify, url_for, send_file
from flask_restful import Resource, Api
import os
import json
from os.path import join, dirname, realpath
from werkzeug.utils import secure_filename
from werkzeug.datastructures import ImmutableMultiDict

UPLOAD_FOLDER = './imgs'

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route('/imgs', methods=['POST'])
def upload_img():
    if 'file' not in request.files:
        return('No file')
    file = request.files['file']
    # if user does not select file, browser also
    # submit an empty part without filename
    if file:
        filename = secure_filename(file.filename)
        file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))

    main('imgs/' + filename).run()
    return ''

@app.route("/imgs_out/<path:path>")
def get_image(path):
    fullpath = "./imgs_out/" + path
    return send_file(fullpath)
