# supermarket-mirror

Mirrors upstream community cookbooks into an internal supermarket using berks.

This does require a service account created in your internal chef/supermarket for uploading

Update /usr/local/bin/nightly_mirror_cookbooks.sh with your:

* http_proxy and https_proxy variables
* knife.rb's
* cookbook_mirror directory with a Berksfile in it.


Cron nightly_mirror_cookbooks.sh as needed.

