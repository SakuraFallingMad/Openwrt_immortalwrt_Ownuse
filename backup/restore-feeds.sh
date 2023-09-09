#!/bin/bash

git checkout . && cd ./feeds

cd ./packages && git checkout . && cd ..

cd ./luci && git checkout . && cd ..

cd ./routing && git checkout . && cd ..

cd ./telephony && git checkout . && cd ..

cd ./kenzo && git checkout . && cd ..

cd ./small && git checkout . && cd ..
