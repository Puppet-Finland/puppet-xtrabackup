#
# == Class: xtrabackup::softwarerepo
#
# Setup Percona's apt repository. This class depends on the "puppetlabs/apt" 
# puppet module:
#
# <https://forge.puppetlabs.com/puppetlabs/apt>
#
class xtrabackup::softwarerepo
(
    $proxy_url
)
{

    if $::osfamily == 'Debian' {

        apt::key { 'xtrabackup-aptrepo':
            key               => '1C4CBDCDCD2EFD2A',
            key_server        => 'keys.gnupg.net',
            key_options       => $proxy_url ? {
                'none'        => undef,
                default       => "http-proxy=\"$proxy_url\"",
            },
        }

        apt::source { 'xtrabackup-aptrepo':
            location          => 'http://repo.percona.com/apt',
            release           => "${::lsbdistcodename}",
            repos             => 'main',
            required_packages => undef,
            pin               => '501',
            include_src       => true,
            require => Apt::Key['xtrabackup-aptrepo'],
        }
    }
}
