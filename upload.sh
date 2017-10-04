#!/bin/bash

git add . && git commit -m "Little change"

knife data bag from file ultimate .chef/encrypted_data_bag.json --secret-file .chef/encrypted_data_bag_secret &
knife role from file roles/*.rb &
knife cookbook upload -a -d &
git push &

wait
