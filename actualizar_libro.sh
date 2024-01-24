#!/bin/bash

# URL del endpoint de autenticación
AUTH_URL="http://localhost:8080/api/v1/auth/signin"

# URL del endpoint protegido libro pasado como parametro
PROTECTED_URL="http://localhost:8080/api/v1/libros/$1"

# Datos de autenticación
AUTH_DATA='{"email":"bob.smith@example.com", "password":"password456"}'

REQUEST_BODY='{"titulo": "'$2'","isbn": "'$3'","autor": "'$4'"}'

# Realiza la solicitud POST para obtener el token
response=$(curl -s -X POST -H "Content-Type:application/json" --data "$AUTH_DATA" $AUTH_URL)

# Extrae el token JWT de la respuesta usando grep y cut
token=$(echo $response | grep -o '"token":"[^"]*' | cut -d'"' -f4)

# Verifica si se obtuvo un token
if [ -z "$token" ]; then
    echo "No se pudo obtener el token JWT"
    exit 1
fi


# Realiza la solicitud GET al endpoint protegido usando el token JWT
curl -v -X PUT -H "Authorization: Bearer $token" $PROTECTED_URL -H "Content-Type:application/json" --data "$REQUEST_BODY"
