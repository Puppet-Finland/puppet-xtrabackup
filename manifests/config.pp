#
# == Class: xtrabackup::config
#
# Configure xtrabackup
#
class xtrabackup::config
(
    $backup_dir
)
{

    file { 'xtrabackup-xtrabackup':
        ensure => directory,
        name => $backup_dir,
        owner => root,
        group => root,
        mode => 750,
    }

}
