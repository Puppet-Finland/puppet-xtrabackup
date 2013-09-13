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
# [*backup_dir*]
#   Directory where backups are placed to. Defaults to 
#   '/var/backups/local/xtrabackup'.
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
class xtrabackup
(
    $backup_dir='/var/backups/local/xtrabackup'
)
{
# Rationale for this is explained in init.pp of the sshd module
if hiera('manage_xtrabackup', 'true') != 'false' {

    include xtrabackup::aptrepo
    include xtrabackup::install

    class { 'xtrabackup::config':
        backup_dir => $backup_dir,
    }
}
}
