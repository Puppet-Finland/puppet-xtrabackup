#
# == Class: xtrabackup
#
# Install and configure xtrabackup. This module depends on the "puppetlabs/apt"
# and "puppetlabs/stdlib" modules:
#
# <https://forge.puppetlabs.com/puppetlabs/apt>
# <https://forge.puppetlabs.com/puppetlabs/stdlib>
#
# == Parameters
#
# None at the moment
#
# == Examples
#
# include xtrabackup
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
# Samuli Seppänen <samuli@openvpn.net>
#
# == License
#
# BSD-lisence
# See file LICENSE for details
#
class xtrabackup {

    include xtrabackup::aptrepo
    include xtrabackup::install

}
