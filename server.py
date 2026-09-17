import os
import json
import secrets
import hashlib
import base64
from datetime import datetime
from flask import Flask, request, jsonify, send_file, abort
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

STORAGE_DIR = 'scripts'
KEY_DIR = 'keys'
os.makedirs(STORAGE_DIR, exist_ok=True)
os.makedirs(KEY_DIR, exist_ok=True)

SECRET = os.environ.get('SHIELD_SECRET', 'change_this_secret_key_2026')

def generate_id():
    return secrets.token_urlsafe(24)

def get_roblox_check():
    ua = request.headers.get('User-Agent', '').lower()
    roblox_agents = ['roblox', 'synapse', 'krnl', 'fluxus', 'script-ware', 'luau', 'robloxapp']
    for a in roblox_agents:
        if a in ua:
            return True
    return False

@app.route('/api/upload', methods=['POST'])
def upload():
    try:
        data = request.get_json()
        code = data.get('code', '')
        key = data.get('key', '')
        
        if not code or not key:
            return jsonify({'ok': False, 'error': 'Missing code or key'}), 400
        
        script_id = generate_id()
        ts = datetime.now().isoformat()
        
        # تشفير إضافي للطبقة الخادمية
        key_hash = hashlib.sha256(key.encode()).hexdigest()[:16]
        server_key = (SECRET + key_hash).encode()[:32].ljust(32, b'0')
        
        encrypted = bytearray()
        code_bytes = code.encode('utf-8')
        for i, b in enumerate(code_bytes):
            encrypted.append(b ^ server_key[i % len(server_key)])
        
        payload = {
            'id': script_id,
            'data': base64.b64encode(bytes(encrypted)).decode(),
            'created': ts,
            'keyhash': key_hash
        }
        
        with open(os.path.join(STORAGE_DIR, script_id + '.json'), 'w') as f:
            json.dump(payload, f)
        
        base_url = request.host_url.rstrip('/')
        raw_url = f'{base_url}/raw/{script_id}'
        
        return jsonify({'ok': True, 'url': raw_url, 'id': script_id})
    
    except Exception as e:
        return jsonify({'ok': False, 'error': str(e)}), 500

@app.route('/raw/<script_id>')
def raw(script_id):
    path = os.path.join(STORAGE_DIR, script_id + '.json')
    if not os.path.exists(path):
        abort(404)
    
    # كشف الطلبات من المتصفح
    if not get_roblox_check():
        abort(403)
    
    with open(path, 'r') as f:
        payload = json.load(f)
    
    return send_file(
        os.path.join(STORAGE_DIR, script_id + '.json'),
        mimetype='text/plain',
        as_attachment=False,
        download_name=script_id + '.lua'
    )

@app.route('/api/delete/<script_id>', methods=['DELETE'])
def delete(script_id):
    path = os.path.join(STORAGE_DIR, script_id + '.json')
    if not os.path.exists(path):
        return jsonify({'ok': False, 'error': 'Not found'}), 404
    os.remove(path)
    return jsonify({'ok': True})

@app.route('/api/list', methods=['GET'])
def list_scripts():
    files = [f[:-5] for f in os.listdir(STORAGE_DIR) if f.endswith('.json')]
    return jsonify({'ok': True, 'scripts': files, 'count': len(files)})

@app.route('/')
def home():
    return 'LUA SHIELD Server Active', 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
