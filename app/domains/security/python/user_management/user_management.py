from flask import Flask, request, jsonify
from werkzeug.security import generate_password_hash

app = Flask(__name__)

# Simulando una base de datos de usuarios
users_db = {}

@app.route('/register', methods=['POST'])
def register():
    data = request.json
    if 'username' not in data or 'password' not in data:
        return jsonify({'message': 'Username and password required'}), 400
    
    # Verifica si el usuario ya existe
    if data['username'] in users_db:
        return jsonify({'message': 'User already exists'}), 409

    # Crea el usuario con una contraseña segura
    hashed_password = generate_password_hash(data['password'], method='sha256')
    users_db[data['username']] = {
        'password': hashed_password,
        'profile': data.get('profile', {})
    }
    return jsonify({'message': 'User created successfully'}), 201

@app.route('/update_profile', methods=['PUT'])
def update_profile():
    data = request.json
    username = data.get('username')
    if not username or username not in users_db:
        return jsonify({'message': 'User not found'}), 404

    users_db[username]['profile'] = data.get('profile', {})
    return jsonify({'message': 'Profile updated successfully'}), 200

@app.route('/get_user_profile', methods=['GET'])
def get_user_profile():
    username = request.args.get('username')
    if username not in users_db:
        return jsonify({'message': 'User not found'}), 404

    return jsonify(users_db[username]['profile']), 200

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5001)
