import requests
from requests.auth import HTTPBasicAuth

_HOST = 'https://0.0.0.0:5601'
_USERNAME = 'elastic'
_PASSWORD = 'some_password'

headers = {
    'kbn-xsrf': 'elk-tls-docker',
    'Content-Type': 'application/json'
}

ENDPOINT = '/api/detection_engine/rules/prepackaged'

response = requests.put(
    _HOST + ENDPOINT, 
    headers=headers, 
    auth=HTTPBasicAuth(_USERNAME, _PASSWORD), 
    verify=False)
print(response.json())