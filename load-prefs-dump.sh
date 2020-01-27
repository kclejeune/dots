#! /usr/bin/env bash

# NOTE: This won't work without importing private key
# fingerprint 117A03CAE0A807366464C3EB767584B12DC335E2
gpg --decrypt ./prefs.plist.gpg | defaults write
