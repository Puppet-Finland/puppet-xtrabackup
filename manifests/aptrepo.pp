#
# == Class: xtrabackup::aptrepo
#
# Setup Percona's apt repository. This class depends on the "puppetlabs/apt" 
# puppet module:
#
# <https://forge.puppetlabs.com/puppetlabs/apt>
#
class xtrabackup::aptrepo {

    apt::source { 'xtrabackup-aptrepo':
        location          => 'http://repo.percona.com/apt',
        release           => "${::lsbdistcodename}",
        repos             => 'main',
        required_packages => undef,
        key               => '1C4CBDCDCD2EFD2A',
        key_server        => 'keys.gnupg.net',
        pin               => '501',
        include_src       => true
    }
}
