#!/usr/bin/python
import oct2py
from flask import Flask
from flask import jsonify
from flask import abort
from flask import make_response
from flask import request
from oct2py import octave
oc = oct2py.Oct2Py()

app = Flask(__name__)

@app.route('/')
def index():
    return "Hello, World!"
target = open('data.txt', 'a')

dataset = []

@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({'error': 'Not found'}), 404)

@app.route('/api/v1.0/dataset', methods=['GET'])
def get_dataset():
    return jsonify({'dataset': dataset})

@app.route('/api/v1.0/dataset', methods=['POST'])
def create_data():
    if not request.json:
        abort(400)
    d = {
        'data': request.json['data']
    }
    print request.json['data']
    dataset.append(d)
    target.write(request.json['data'] + "\n")
    return jsonify({'data': d}), 201

@app.route('/api/v1.0/predict', methods=['POST'])
def predict_data():
    if not request.json:
        abort(400)
    test = open('testdata.txt', 'w')
    d = {
        'data': request.json['data']
    }
    test.write(request.json['data'] + "\n")
    oc.addpath("~/")
    test.close()
    prediction = oc.actualpredict()
    print(prediction) 
    return jsonify({'prediction': prediction}), 201
if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=80)
