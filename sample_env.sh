#!/bin/bash

export SAMPLE_ENV=`cat sample_env.json`
embulk preview scraping.yml.liquid -b ./ -I ./ -G
