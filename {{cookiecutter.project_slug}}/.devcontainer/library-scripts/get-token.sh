#!/bin/bash

TOKEN=$(jupyter lab list | grep -o 'token=[[:alnum:]]*' | sed 's/token=//')

echo "Login Token: $TOKEN"
