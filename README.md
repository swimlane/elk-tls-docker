# Setting up TLS ELK Stack

This repository will setup a certificate (TLS) communication based ELK stack.  This will allow you to use features like built-in detections and the SIEM features in Kibana.

We will create three ELK 7.8.0 containers:

* Elasticsearch
* Logstash
* Kibana

## Setup

To use this, first include only the following in the [.env](.env) file:

```
ELK_VERSION=7.8.0
ELASTIC_USERNAME=elastic
ELASTIC_PASSWORD={some_password}
```

## Certificates

Before we build or create our containers we first need to get some certificates.  You can do this using the [docker-compose.setup.yml](docker-compose.setup.yml) yaml file.  Additionally if you run into issues you can see the associated documentation [here](CERTIFICATES.md)

```
docker-compose -f docker-compose.setup.yml run --rm certs
```

Once you run this yaml file, you should have all necessary certificates/keys.  Next we need to set passwords.

## Running ELK

The first thing you will is set passwords for all accounts within ELK.

Let's run our ELK stack now:

```
docker-compose up -d
```

## Set Passwords

You will need to set passwords for all accounts.  I recommend in a tesitng environment to create a single password and use this across all accounts - it makes it easier when troublehshooting.

We need to access the elasticsearch container and generate our passwords:

```
docker-compose exec elasticsearch bash
> bin/elasticsearch-setup-passwords interactive
# Set passwords for all accounts when prompted
```

## Finish

Now, that you have your keys/certs and passwords set we can then just restart the containers by running:

```
docker-compose up -d
```

You should be able to login into the ELK stack and be on your way.

## Enabling features

This section talks about enabling features within Kibana and the Security stack.

### Creating a Default SIEM Space

In order to access signals and install pre-packaged rules within elasticsearch & kibana we first need to create a default space.  You can do this in the UI but below is some python code to help you create this:

```python
import requests
from requests.auth import HTTPBasicAuth

_HOST = 'https://0.0.0.0:5601'
_USERNAME = 'elastic'
_PASSWORD = 'some_password'

headers = {
    'kbn-xsrf': 'Swimlane',
    'Content-Type': 'application/json'
}

ENDPOINT = '/api/spaces/space'

body = {
    'id': 2,
    'name': '.siem-signals-default',
    'description': 'Default SIEM signals space'
}

response = requests.put(
    _HOST + ENDPOINT, 
    headers=headers, 
    auth=HTTPBasicAuth(_USERNAME, _PASSWORD), 
    data=body, 
    verify=False)
print(response.json())
```

### Loading pre-packaged rules

To access or load elastic's pre-packaged signals (detection rules) you can run the following after creating the default space above.

```python
import requests
from requests.auth import HTTPBasicAuth

_HOST = 'https://0.0.0.0:5601'
_USERNAME = 'elastic'
_PASSWORD = 'some_password'

headers = {
    'kbn-xsrf': 'Swimlane',
    'Content-Type': 'application/json'
}

# PUT - Add pre-built rules to Kibana SIEM
ENDPOINT = '/api/detection_engine/rules/prepackaged'

response = requests.put(
    _HOST + ENDPOINT, 
    headers=headers, 
    auth=HTTPBasicAuth(_USERNAME, _PASSWORD), 
    verify=False)
print(response.json())
```

## Adding Data to Kibana

You can also add fake data to kibana using Swimlane's `soc-faker`.  You install it using pip:

```python
pip install soc-faker
```

Next you can add fake windows event log data to elastic running the following:

```python
from elasticsearch import Elasticsearch, RequestsHttpConnection
from socfaker import SocFaker


soc_faker = SocFaker()

_HOST = 'https://0.0.0.0:9200'
_USERNAME = 'elastic'
_PASSWORD = 'some_password'

es = Elasticsearch([_HOST],http_auth=(_USERNAME, _PASSWORD), verify_certs=False)

count = 1
for doc in soc_faker.products.elastic.document(count=1000):
    # adding documents to the winlogbeat- index
    es.index(index='winlogbeat-', id=count, body=doc)
    count += 1

```
