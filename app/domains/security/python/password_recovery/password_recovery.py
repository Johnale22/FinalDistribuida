from flask import Flask, request, jsonify
from werkzeug.security import generate_password_hash

app = Flask(__name__)

# Simulando una base de datos de usuarios
users_db = {
    "admin": {"password": "hashed_password_here"}
}

@app.route('/recover_password', methods=['POST'])
def recover_password():
    username = request.json.get('username')
    new_password = request.json.get('new_password')
    
    if username not in users_db:
        return jsonify({'message': 'User not found'}), 404

    # Cambiar la contraseña
    hashed_password = generate_password_hash(new_password, method='sha256')
    users_db[username]['password'] = hashed_password
    return jsonify({'message': 'Password updated successfully'}), 200

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5004)
