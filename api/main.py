from app import app
from extract_data import extract_data
from flask import jsonify, request
import logging

app.logger.setLevel(logging.DEBUG)

@app.route('/extract')
def extract():
	try:
		rows = extract_data()
		message = {
        'status': 200,
        'message': f'{rows} records loaded to db',
		}
		resp = jsonify(message)
		resp.status_code = 200
		return resp
	except Exception as e:
		app.logger.error(e)
		
		
@app.errorhandler(404)
def not_found(error=None):
    message = {
        'status': 404,
        'message': 'Not Found: ' + request.url,
    }
    resp = jsonify(message)
    resp.status_code = 404
    return resp
		
if __name__ == "__main__":
    app.run(host='0.0.0.0')