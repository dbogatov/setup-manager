#!/bin/bash

git add . && git commit -m "Little change"

knife role from file roles/*.rb &
knife cookbook upload -a -d &
git push &

wait
