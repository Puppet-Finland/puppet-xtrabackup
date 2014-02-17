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
# [*proxy_url*]
#   The proxy URL used for fetching the xtrabackup software repository public 
#   keys. For example "http://proxy.domain.com:8888". Not needed if the node has 
#   direct Internet connectivity, or if you're installing xtrabackup from your 
#   operating system repositories. Defaults to 'none' (do not use a proxy).
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
    $proxy_url = 'none',
    $backup_dir='/var/backups/local/xtrabackup'
)
{
# Rationale for this is explained in init.pp of the sshd module
if hiera('manage_xtrabackup', 'true') != 'false' {

    class { 'xtrabackup::softwarerepo':
        proxy_url => $proxy_url,
    }

    include xtrabackup::install

    class { 'xtrabackup::config':
        backup_dir => $backup_dir,
    }
}
}
