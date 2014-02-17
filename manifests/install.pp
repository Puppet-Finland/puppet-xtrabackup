#
# == Class: xtrabackup::install
#
# Install xtrabackup
#
class xtrabackup::install {

    package { 'xtrabackup-percona-xtrabackup':
        name => 'xtrabackup',
        ensure => installed,
        require => Class['xtrabackup::softwarerepo'],
    }

}
