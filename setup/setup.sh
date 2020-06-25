# Exit on Error
set -e


OUTPUT_FILE=/secrets/elasticsearch.keystore
NATIVE_FILE=/usr/share/elasticsearch/config/elasticsearch.keystore


# Create Keystore
printf "========== Creating Elasticsearch Keystore ==========\n"
printf "=====================================================\n"
elasticsearch-keystore create >> /dev/null

# Setting Secrets

## Setting Bootstrap Password
echo "Setting bootstrap.password..."
(echo "$ELASTIC_PASSWORD" | elasticsearch-keystore add -x 'bootstrap.password')
echo "Elastic password is: $ELASTIC_PASSWORD"


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
CA_FILE=$OUTPUT_DIR/elastic-stack-ca.p12
CERT_FILE=$OUTPUT_DIR/elastic-certificates.p12
ZIP_FILE=$OUTPUT_DIR/ssl-cert.zip
CRT_FILE=$OUTPUT_DIR/instance.crt
KEY_FILE=$OUTPUT_DIR/instance.key
PEM_FILE=$OUTPUT_DIR/logstash.pem

yum install unzip openssl -y
printf "====== Generating Elasticsearch Certifications ======\n"
printf "=====================================================\n"
if [ -f "$CA_FILE" ]; then
    echo "Removing current Certificate Authority (CA)..."
    rm $CA_FILE
fi
if [ -f "$CERT_FILE" ]; then
    echo "Removing current Certificate (P12)..."
    rm $CERT_FILE
fi
if [ -f "$ZIP_FILE" ]; then
    echo "Removing current PEM File (ssl-cert.zip)..."
    rm $ZIP_FILE
fi
elasticsearch-certutil ca -s --pass "" --out $CA_FILE
elasticsearch-certutil cert -s --ca $CA_FILE --ca-pass "" --out $CERT_FILE --pass ""
elasticsearch-certutil cert --pem -ca $CA_FILE --ca-pass "" --out $ZIP_FILE
unzip $ZIP_FILE
mv "instance/instance.crt" $CRT_FILE
mv "instance/instance.key" $KEY_FILE
rm $ZIP_FILE
chmod 0644 $CA_FILE
chmod 0644 $CERT_FILE
chmod 0644 $CRT_FILE
chmod 0644 $KEY_FILE

openssl pkcs12 -in $CERT_FILE -out $PEM_FILE -clcerts -nokeys -passin pass:""
chmod 0644 $PEM_FILE
printf "Certificate Authority created at $CA_FILE\n"
printf "Certificate created at $CERT_FILE\n"
printf "=====================================================\n"
printf "SSL Certifications generation completed successfully.\n"
printf "=====================================================\n"
