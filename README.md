# letsEncryptRelocator

A very small (and until now incomplete) shell script to relocate all files of a Let's Encrypt certificate to another server. I have created and used it many times as I have migrated many websites from one dedicated server to another and got sick of copying so many files per certificates.

Be warned: it's neither complete nor perfect - right now it's just working as much as I needed it. Going to extend it soon (as you already might notice by the planned parameters.

## Basic usage
./letsEncryptRelocator.sh -n nameOfYourCert -h target.host.name

nameOfYourCert: if you make an ls in /etc/letsencrypt/live this is the folder name you'll see in this lising
target.host.name: the target hostname to copy the files to
