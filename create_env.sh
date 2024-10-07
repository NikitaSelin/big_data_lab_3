#!/bin/bash
cd big_data_lab_3
touch ansible-password.txt
echo "$VAULT_CREDS_PSW" > ansible-password.txt
ansible-playbook setup.yml --vault-password-file ansible-password.txt