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
# [*manage*]
#   Whether to manage xtrabackup using Puppet. Valid values are true (default) 
#   and false.
# [*proxy_url*]
#   The proxy URL used for fetching the xtrabackup software repository public 
#   keys. For example "http://proxy.domain.com:8888". Not needed if the node has 
#   direct Internet connectivity, or if you're installing xtrabackup from your 
#   operating system repositories. Defaults to 'none' (do not use a proxy).
# [*backup_dir*]
#   Directory where backups are placed to. Defaults to 
#   '/var/backups/local/xtrabackup'.
# [*backups*]
#   A hash of xtrabackup::backup resources to realize.
#
# == Examples
#
#   include xtrabackup
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
#
# Samuli Seppänen <samuli@openvpn.net>
#
# == License
#
# BSD-license. See file LICENSE for details.
#
class xtrabackup
(
    Boolean $manage = true,
    String  $proxy_url = 'none',
    String  $backup_dir = '/var/backups/local/xtrabackup',
    Hash    $backups = {}
)
{

if $manage {

    class { '::xtrabackup::softwarerepo':
        proxy_url => $proxy_url,
    }

    include ::xtrabackup::install

    class { '::xtrabackup::config':
        backup_dir => $backup_dir,
    }

    # Realize the defined backup jobs
    create_resources('xtrabackup::backup', $backups)
}
}
