#!/bin/bash

echo "Welcome to the ecc site uploader :)"
cd gcp-foundations/overlays/test/website
gsutil cp -r . gs://demo.ecc.BUCKET-NAME-PLACEHOLDER
