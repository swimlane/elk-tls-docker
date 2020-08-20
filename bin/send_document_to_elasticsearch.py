from socfaker import SocFaker
import requests, json
from requests.auth import HTTPBasicAuth


_HOST = 'https://0.0.0.0:9200'
_INDEX = 'winlogbeat' # if it doesn't it exist it will be created
_USERNAME = 'elastic'
_PASSWORD = 'some_password'

headers = {
    'kbn-xsrf': 'elk-tls-docker',
    'Content-Type': 'application/json'
}

ENDPOINT = f'/{_INDEX}/_doc'

soc_faker = SocFaker()

import pprint, pendulum
count = 1
while count <=100:
    for doc in soc_faker.products.elastic.document.get(count=1):
        doc['event']['created'] = pendulum.now().to_iso8601_string()
        doc['event']['start'] = pendulum.now().to_iso8601_string()
        response = requests.post(
            _HOST + ENDPOINT, 
            headers=headers,
            data=json.dumps(doc), 
            auth=HTTPBasicAuth(_USERNAME, _PASSWORD), 
            verify=False)
        print(response.json())
    count+=1