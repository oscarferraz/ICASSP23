#!/bin/bash
rm log.txt

bash power.sh 2>&1 | tee log.txt