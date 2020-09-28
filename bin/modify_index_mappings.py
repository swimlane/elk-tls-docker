import requests
from requests.auth import HTTPBasicAuth


_HOST = 'https://0.0.0.0:9200'
_INDEX = 'winlogbeat' # if it doesn't it exist it will be created
_USERNAME = 'elastic'
_PASSWORD = 'some_password'

headers = {
    'kbn-xsrf': 'elk-tls-docker',
    'Content-Type': 'application/json'
}

ENDPOINT = f'/{_INDEX}/_mapping'

body = {
    "properties": {
        "host": {
            "properties": {
                "name": {
                    "type": "text",
                    "fielddata": True
                },
                "hostname": {
                    "type": "text",
                    "fielddata": True
                },
                "ip": {
                    "type": "text",
                    "fielddata": True
                },
            }
        },
        "event": {
            "properties": {
                "action": {
                    "type": "text",
                    "fielddata": True
                },
                "dataset": {
                    "type": "text",
                    "fielddata": True
                },
                "module": {
                    "type": "text",
                    "fielddata": True
                }
            }
        },
        "organization": {
            "properties": {
                "name": {
                    "type": "text",
                    "fielddata": True
                }
            }
        },
        "os": {
            "properties": {
                "full": {
                    "type": "text",
                    "fielddata": True
                }
            }
        },
        "file": {
            "properties": {
                "path": {
                    "type": "text",
                    "fielddata": True
                }
            }
        },
        "http": {
            "properties": {
                "request": {
                    "properties": {
                        "body": {
                            "properties": {
                                "content": {
                                    "type": "text",
                                    "fielddata": True
                                }
                            }
                        }
                    }
                },
                "response": {
                    "properties": {
                        "body": {
                            "properties": {
                                "content": {
                                    "type": "text",
                                    "fielddata": True
                                }
                            }
                        }
                    }
                }
            }
        },
        "destination": {
            "properties": {
                "ip": {
                    "type": "text",
                    "fielddata": True
                },
                "geo": {
                    "properties": {
                        "country_iso_code": {
                            "type": "text",
                            "fielddata": True
                        }
                    }
                }
            }
        },
        "source": {
            "properties": {
                "ip": {
                    "type": "text",
                    "fielddata": True
                },
                "geo": {
                    "properties": {
                        "country_iso_code": {
                            "type": "text",
                            "fielddata": True
                        }
                    }
                }
            }
        }
    }
}

response = requests.put(
    _HOST + ENDPOINT, 
    headers=headers,
    json=body, 
    auth=HTTPBasicAuth(_USERNAME, _PASSWORD), 
    verify=False)
print(response.json())
