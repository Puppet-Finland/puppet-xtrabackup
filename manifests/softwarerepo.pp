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

) inherits xtrabackup::params
{

    if $::osfamily == 'Debian' {

        include ::apt

        $key_options = $proxy_url ? {
            'none'        => undef,
            default       => "http-proxy=\"${proxy_url}\"",
        }

        apt::source { 'xtrabackup-aptrepo':
            location => 'http://repo.percona.com/apt',
            release  => $::lsbdistcodename,
            repos    => 'main',
            pin      => '501',
            key      => {
                'id'      => '430BDF5C56E7C94E848EE60C1C4CBDCDCD2EFD2A',
                'server'  => 'keys.gnupg.net',
                'options' => $key_options,
            },
            include  => {
                'src' => true,
                'deb' => true,
            },
        }
    }
}
