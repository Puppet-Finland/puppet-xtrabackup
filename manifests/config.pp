#
# == Class: xtrabackup::config
#
# Configure xtrabackup
#
class xtrabackup::config
(
    String $backup_dir

) inherits xtrabackup::params
{

    file { 'xtrabackup-xtrabackup':
        ensure => directory,
        name   => $backup_dir,
        owner  => $::os::params::adminuser,
        group  => $::os::params::admingroup,
        mode   => '0750',
    }

}
