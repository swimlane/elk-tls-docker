from socfaker import SocFaker
import requests, json
from requests.auth import HTTPBasicAuth


_HOST = 'https://0.0.0.0:9200'
ENDPOINT = '/_security/user/soc'

_USERNAME = 'elastic'
_PASSWORD = 'some_password'

headers = {
    'kbn-xsrf': 'elk-tls-docker',
    'Content-Type': 'application/json'
}

_BODY = {
    'email': 'soc@company.com',
    'full_name': 'SOC',
    'password': 'some_password',
    'roles': ['superuser']
}

response = requests.post(
    _HOST + ENDPOINT, 
    headers=headers,
    data=json.dumps(_BODY), 
    auth=HTTPBasicAuth(_USERNAME, _PASSWORD), 
    verify=False)
print(response.json())