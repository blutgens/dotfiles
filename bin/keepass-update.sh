#!/bin/bash
pushd ~/Dropbox
smbget -q -U -u blutgens -p MM712fr3 -w UAFP_DOMAIN smb://ucadmin3-v/Netsvcs/IS1.kdbx
