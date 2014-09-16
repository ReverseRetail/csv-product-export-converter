#!/bin/bash -l
cd "$(dirname "$0")"
ruby lib/CsvTransformer.rb $1 $2