#!/bin/bash

mkdir -p "/address"
DATABASE_FILE="/address/address.db"

cat /root/data-prep/tablePopulator.sql | sqlite3 ${DATABASE_FILE}
