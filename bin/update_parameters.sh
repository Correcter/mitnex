#!/usr/bin/env bash

echo -en "- Updating parameters from dist...\n"
cp app/config/app_com/parameters.yml.dist app/config/app_com/parameters.yml
cp app/config/app_ru/parameters.yml.dist app/config/app_ru/parameters.yml
cp app/config/app_pps/parameters.yml.dist app/config/app_pps/parameters.yml
