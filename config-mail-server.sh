#!/usr/bin/env bash

docker exec mailer-service-prod postconf -e 'smtp_use_tls = yes'

docker exec mailer-service-prod postfix reload