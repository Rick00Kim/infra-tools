#!/bin/bash

# Check Before
if [ ! -d "$HOME/.oci" ] 
then
    echo "Directory $HOME/.oci DOES NOT exists." 
    echo "It will be create $HOME/.oci directory"
    mkdir -p $HOME/.oci
fi

# Create RSA key
input_val=""
read -p "RSA key's prefix string. (Default -> $(uname -n)) -> " input_val
if [ -z $input_val ]; then
    echo "It will be create by default prefix"
    input_val=$(uname -n)
fi

# echo $input_val
# Create RSA private key
openssl genrsa -out $HOME/.oci/${input_val}_rsa.pem 2048

# Set permission to RSA private key
chmod 600 $HOME/.oci/${input_val}_rsa.pem

# Create RSA Public key
openssl rsa -pubout -in $HOME/.oci/${input_val}_rsa.pem -out $HOME/.oci/${input_val}_rsa_public.pem

# Output
echo "It is successful for creating RSA private and public keys"
echo "Please paste publc key(below) to OCI console API key set"
cat $HOME/.oci/${input_val}_rsa_public.pem

