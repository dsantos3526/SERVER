#!/bin/sh
#https://gist.github.com/kevinadi/96090f6f9973ff8c2d019bbe0d9a0f70

# Generate self signed root CA cert
openssl req -nodes -x509 -newkey rsa:2048 -keyout ca.key -out ca.crt -subj "/C=AU/ST=NSW/L=Sydney/O=MongoDB/OU=root/CN=`hostname -f`/emailAddress=kevinadi@mongodb.com"


# Generate server cert to be signed
openssl req -nodes -newkey rsa:2048 -keyout server.key -out server.csr -subj "/C=AU/ST=NSW/L=Sydney/O=MongoDB/OU=server/CN=`hostname -f`/emailAddress=kevinadi@mongodb.com"

# Sign the server cert
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt

# Create server PEM file
cat server.key server.crt > server.pem


# Generate client cert to be signed
openssl req -nodes -newkey rsa:2048 -keyout client.key -out client.csr -subj "/C=AU/ST=NSW/L=Sydney/O=MongoDB/OU=client/CN=`hostname -f`/emailAddress=kevinadi@mongodb.com"

# Sign the client cert
openssl x509 -req -in client.csr -CA ca.crt -CAkey ca.key -CAserial ca.srl -out client.crt

# Create client PEM file
cat client.key client.crt > client.pem


# Create clientPFX file (for Java, C#, etc)
# openssl pkcs12 -inkey client.key -in client.crt -export -out client.pfx


# Start mongod with SSL
# mkdir -p data/db
# mongod --sslMode requireSSL --sslPEMKeyFile server.pem --sslCAFile ca.crt --dbpath data/db --logpath data/mongod.log --fork

# Connect to mongod with SSL
# mongo --ssl --sslCAFile ca.crt --sslPEMKeyFile client.pem --host `hostname -f`



#https://techoverflow.net/2019/04/02/how-to-generate-diffie-hellman-dh-parameters-using-openssl/
#Create dhparam

openssl dhparam -out dhparams.pem 4096
