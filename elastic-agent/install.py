import os
import time
from elastic_agent_setup import ElasticAgent


if __name__ == "__main__":
    agent = ElasticAgent()
    verify_ssl = False if os.environ.get('FLEET_ENROLL_INSECURE') else True
    agent.configure(
        os.environ.get('ELASTICSEARCH_USERNAME'),
        os.environ.get('ELASTICSEARCH_PASSWORD'),
        kibana=os.environ.get('KIBANA_HOST', 'https://localhost:5601'),
        elasticsearch=os.environ.get('ELASTICSEARCH_HOSTS', 'https://localhost:9200'),
        force_enroll='--force' if os.environ.get('ENROLL_FORCE') else '',
        certificate_authority=os.environ.get('FLEET_CA'),
        verify_ssl=verify_ssl
    )
    preflight = True if os.environ.get('PREFLIGHT_CHECK') else False
    agent.install(version=os.environ.get('ELK_VERSION'), preflight_check=preflight)
    while True:
        print('Elastic Agent is running .....', flush=True)
        time.sleep(30)
