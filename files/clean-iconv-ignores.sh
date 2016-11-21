#!/bin/sh
find /DATA/htdocs -type f -exec sed -i "s|'utf-8//IGNORE'|'utf-8'|g" {} +