# Manually Generating Certificates

We first need to get a Certificate Authority (CA) Certificate from the elasticsearch container.

Run the [docker-compose.setup.yml](docker-compose.setup.yml) with the following:

```
docker-compose -f docker-compose.setup.yml up -d
```

## Get CA Certificate

Once those containers are running then we need to exec into the container:

```bash
docker-compose exec keystore bash
```

Once in the container we then invoke the built-in executable in the bin directory to generate our CA certificate:

```bash
bin/elasticsearch-certutil ca
```

## Getting Certificates

> Please note that I am creating a certificate for all other services (e.g. kibana, logstash) but depending on your setup you probably should create one for each

Let's use our recently generated CA certificate to generate a certificate.  You should still be in the same container we were already in to generate the CA certificate:

```
bin/elasticsearch-certutil cert --ca elastic-stack-ca.p12
```

While we are still in this container, let's set passwords for all user accounts

## Set Passwords for all users

> Probably best to use the same password for all users when in a demo enviornment only

```
bin/elasticsearch-setup-passwords interactive
```

We are still in the container....

## Get PEM for Kibana

> This is actually outputted as a crt and key in a zip file

Run the following command to generate a PEM file for Kibana

```
bin/elasticsearch-certutil cert --pem -ca elastic-stack-ca.p12
```

## Copying Files to local system

Now that we have generated the necessary files, let's exit the container by typing `exit` and while in the same folder as your docker-compose.setup.yml let's run the following:

```bash
docker cp {CONTAINER_ID}:/usr/share/elasticsearch/elastic-certificates.p12 secrets/elastic-certificates.p12
docker cp {CONTAINER_ID}:/usr/share/elasticsearch/elastic-stack-ca.p12 secrets/elastic-stack-ca.p12
docker cp {CONTAINER_ID}:/usr/share/elasticsearch/certificate-bundle.zip secrets/certificate-bundle.zip

# Finally let's unzip the contents of the certificate-bundle.zip and put them in the secrets folder
unzip secrets/certificate-bundle.zip -d ./secrets
```

## Get logstash PEM

Now that we have these files, let's now generate an actual `.pem` file needed by logstash.  You do this using openssl:

```
openssl pkcs12 -in secrets/elastic-certificates.p12 -out secrets/logstash.pem -clcerts -nokeys
```

## Finish

That's it - well it's a pain in the butt and took awhile to figure this out but for you that's it :)

You should have the following files in your [secrets](secrets) directory:

* elastic-certificates.p12
* elastic-stack-ca.p12
* instance.crt
* instance.key
* logstash.pem

Additionally, when you are done you will also have another file as well:

* elasticsearch.keystore