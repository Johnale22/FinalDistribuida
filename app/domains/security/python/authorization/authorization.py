from flask import Flask, jsonify, request

app = Flask(__name__)

# Simulando roles y permisos de los usuarios
roles_permissions = {
    "admin": ["read", "write", "delete"],
    "user": ["read"]
}

@app.route('/check_permission', methods=['GET'])
def check_permission():
    username = request.args.get('username')
    required_permission = request.args.get('permission')

    # Asignar un rol para este ejemplo
    user_role = "admin" if username == "admin" else "user"

    if required_permission in roles_permissions.get(user_role, []):
        return jsonify({'message': 'Permission granted'}), 200
    return jsonify({'message': 'Permission denied'}), 403

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5003)
