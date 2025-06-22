from flask import Flask, request, jsonify
import jwt
import datetime
from werkzeug.security import check_password_hash

app = Flask(__name__)
SECRET_KEY = "my_secret_key"

# Simulando una base de datos de usuarios
users_db = {
    "admin": {
        "password": "hashed_password_here",  # Este debería estar en formato hash
        "profile": {}
    }
}

@app.route('/login', methods=['POST'])
def login():
    auth = request.json
    if not auth or not auth.get('username') or not auth.get('password'):
        return jsonify({'message': 'Username and password required'}), 400
    
    user = users_db.get(auth['username'])
    if not user or not check_password_hash(user['password'], auth['password']):
        return jsonify({'message': 'Invalid credentials'}), 401

    # Generación de JWT
    token = jwt.encode({
        'user': auth['username'],
        'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=1)
    }, SECRET_KEY, algorithm='HS256')

    return jsonify({'token': token})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5002)
