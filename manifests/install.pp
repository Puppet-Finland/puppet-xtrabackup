#
# == Class: xtrabackup::install
#
# Install xtrabackup
#
class xtrabackup::install inherits xtrabackup::params {

    package { 'xtrabackup-percona-xtrabackup':
        ensure  => installed,
        name    => 'xtrabackup',
        require => Class['xtrabackup::softwarerepo'],
    }

}
