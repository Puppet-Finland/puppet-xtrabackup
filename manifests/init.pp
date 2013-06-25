#
# == Class: xtrabackup
#
# Install and configure xtrabackup. This module depends on the "puppetlabs/apt"
# puppet module:
#
# <https://forge.puppetlabs.com/puppetlabs/apt>
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
