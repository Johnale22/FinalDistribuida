from flask import Flask, jsonify, request
import logging

app = Flask(__name__)

# Configuración de logging
logging.basicConfig(filename='audit.log', level=logging.INFO)

@app.route('/log_action', methods=['POST'])
def log_action():
    action = request.json.get('action')
    user = request.json.get('user')

    if not action or not user:
        return jsonify({'message': 'Action and user are required'}), 400

    log_message = f"User: {user} performed action: {action}"
    logging.info(log_message)

    return jsonify({'message': 'Action logged successfully'}), 200

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5005)
