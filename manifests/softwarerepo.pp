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
    String $proxy_url

) inherits xtrabackup::params
{

    if $::osfamily == 'Debian' {

        include ::apt

        $key_options = $proxy_url ? {
            'none'        => undef,
            default       => "http-proxy=\"${proxy_url}\"",
        }

        apt::key { 'percona-apt-key':
            ensure  => 'present',
            id      => '4D1BB29D63D98E422B2113B19334A25F8507EFA5',
            content => template('xtrabackup/percona.key.erb'),
            options => $key_options,
        }

        apt::source { 'xtrabackup-aptrepo':
            location => 'http://repo.percona.com/apt',
            release  => $::lsbdistcodename,
            repos    => 'main',
            pin      => '501',
            include  => {
                'src' => true,
                'deb' => true,
            },
            require  => Apt::Key['percona-apt-key'],
        }
    }
}
