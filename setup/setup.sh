# Exit on Error
set -e

CONFIG_DIR=/usr/share/elasticsearch/config
OUTPUT_FILE=/secrets/elasticsearch.keystore
NATIVE_FILE=$CONFIG_DIR/elasticsearch.keystore


# Create Keystore
printf "========== Creating Elasticsearch Keystore ==========\n"
printf "=====================================================\n"
elasticsearch-keystore create >> /dev/null

# Setting Secrets

## Setting Bootstrap Password
echo "Setting bootstrap.password..."
(echo "$ELASTIC_PASSWORD" | elasticsearch-keystore add -x 'bootstrap.password')


# Replace current Keystore
if [ -f "$OUTPUT_FILE" ]; then
    echo "Remove old elasticsearch.keystore"
    rm $OUTPUT_FILE
fi

echo "Saving new elasticsearch.keystore"
mv $NATIVE_FILE $OUTPUT_FILE
chmod 0644 $OUTPUT_FILE

printf "======= Keystore setup completed successfully =======\n"
printf "=====================================================\n"

OUTPUT_DIR=/secrets
CA_ZIP=$OUTPUT_DIR/ca.zip
CA_CERT=$OUTPUT_DIR/ca/ca.crt
CA_KEY=$OUTPUT_DIR/ca/ca.key
BUNDLE_ZIP=$OUTPUT_DIR/bundle.zip

yum install unzip openssl -y

printf "====== Generating Elasticsearch Certificates ======\n"
printf "=====================================================\n"
if [ -f "$CA_ZIP" ]; then
    echo "Removing current Certificate Authority (CA)..."
    rm $CA_ZIP
fi

if [ -f "$CA_CERT" ]; then
    echo "Removing current Certificate Authority (CA) certificate..."
    rm $CA_CERT
fi

if [ -f "$CA_KEY" ]; then
    echo "Removing current Certificate Authority (CA) key..."
    rm $CA_KEY
fi

if [ -f "$BUNDLE_ZIP" ]; then
    echo "Removing bundle.zip (e.g. tls certificates)..."
    rm $BUNDLE_ZIP
fi

if [ -d "$OUTPUT_DIR/elasticsearch" ]; then
    echo "Removing elasticsearch certificates folder...."
    rm -rf "$OUTPUT_DIR/elasticsearch"
fi

if [ -d "$OUTPUT_DIR/kibana" ]; then
    echo "Removing kibana certificates folder...."
    rm -rf "$OUTPUT_DIR/kibana"
fi

if [ -d "$OUTPUT_DIR/logstash" ]; then
    echo "Removing logstash certificates folder...."
    rm -rf "$OUTPUT_DIR/logstash"
fi

echo "Generating Certificate Authority"
bin/elasticsearch-certutil ca -s --pass "" --pem --out $CA_ZIP
unzip $CA_ZIP -d $OUTPUT_DIR


echo "Generating a certificate and private keys"
bin/elasticsearch-certutil cert -s --ca-cert $OUTPUT_DIR/ca/ca.crt --ca-key $OUTPUT_DIR/ca/ca.key --ca-pass "" --pem --in $CONFIG_DIR/instances.yml --out $BUNDLE_ZIP
unzip $BUNDLE_ZIP -d $OUTPUT_DIR

echo "Convert logstash.key to PKCS#8 format for Beats input plugin"
openssl pkcs8 -in $OUTPUT_DIR/logstash/logstash.key -topk8 -nocrypt -out $OUTPUT_DIR/logstash/logstash.pkcs8.key

chown -R 1000:0 $OUTPUT_DIR

#echo "Generating certificates for encrypting HTTP client communications"
#echo "Follow the prompts and provide the generated CA from above."
#echo "This CA is located: /secrets/elastic-stack-ca.p12"
#elasticsearch-certutil http

#chmod 0644 "/secrets/elasticsearch-ssl-http.zip"
#unzip "/secrets/elasticsearch-ssl-http.zip"
#mv "/secrets/elasticsearch/http.p12" "/secrets/elasticsearch_http.p12"
#mv "/secrets/kibana/elasticsearch-ca.pem" "/secrets/elasticsearch_kibana_ca.pem"

#elasticsearch-certutil cert --pem -ca $CA_FILE --ca-pass "" --out $ZIP_FILE
#unzip $ZIP_FILE
#mv "instance/instance.crt" $CRT_FILE
#mv "instance/instance.key" $KEY_FILE
#rm $ZIP_FILE


#chmod 0644 $CRT_FILE
#chmod 0644 $KEY_FILE

#openssl pkcs12 -in $CERT_FILE -out $PEM_FILE -clcerts -nokeys -passin pass:""
#chmod 0644 $PEM_FILE
#printf "Certificate Authority created at $CA_FILE\n"
#printf "Certificate created at $CERT_FILE\n"
#printf "=====================================================\n"
#printf "SSL Certifications generation completed successfully.\n"
#printf "=====================================================\n"