#!/bin/bash
pushd ~/Dropbox
smbget -q -U -u <username> -p <password> -w <domain> smb://<filename>
