mkdir -p /etc/puppet/modules
puppet module install puppetlabs/apt
puppet module install puppetlabs/nginx

apt-get update
