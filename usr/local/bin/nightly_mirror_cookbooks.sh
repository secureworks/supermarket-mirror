#!/bin/bash
logfile=/var/log/supermarket/sync.log
PATH=/opt/chef/bin/:/opt/chef/embedded/bin/:$PATH
https_proxy='YOURCORPORATEPROXY'
http_proxy=$https_proxy
export http_proxy https_proxy PATH

cd /var/opt/chef/cookbook_mirror
echo "Cookbook sync on $(hostname) for $(date +%F)" >>$logfile
berks update >>$logfile 2>&1
berks vendor >>$logfile 2>&1

for cookbook in berks-cookbooks/*; do
 for config in ~/.chef/knife.rb_site_a ~/.chef/knife.rb_site_b; do
  test -f $cookbook/metadata.json && /usr/local/bin/parse_metadata.rb < $cookbook/metadata.json > $cookbook/metadata.rb
  touch $cookbook/README.md

  myver=$(awk -F\' '/version/ {print $2}' $cookbook/metadata.rb )
  prodver=$(knife cookbook list -c $config | awk -v re=$(basename $cookbook) '$1 ~ re { print $2 }')
  uploadytime=$( /opt/chef/embedded/bin/ruby -e "puts true if Gem::Version.new('$myver') > Gem::Version.new('$prodver')" )

  if [ "$uploadytime" == "true" ]; then
   knife cookbook upload $(basename $cookbook) -o berks-cookbooks/ -c $config >>$logfile 2>&1
   knife supermarket share $(basename $cookbook) -o berks-cookbooks/ -c $config >>$logfile 2>&1
  else
   echo "Skipping upload - $cookbook is not an update"
  fi
 done
done
