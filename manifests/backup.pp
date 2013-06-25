#
# == Define: xtrabackup::backup
#
# Dump mysql databases to a directory using xtrabackup
# 
# This define depends on the 'localbackups' class. Also, the 'xtrabackup' class 
# has to be included or this define won't be found.
#
# == Parameters
#
# [*status*]
#   Status of the backup job. Either 'present' or 'absent'. Defaults to 
#   'present'.
# [*databases*]
#   An array containing the names of databases to back up. Defaults to ['all'], 
#   which backs up all databases.
# [*incremental*]
#   Whether to do an incremental backup. Valid values true and false. Defaults 
#   to false. For correct behavior a full backup has to be created before the 
#   incremental one.
# [*output_dir*]
#   The directory where to output the files. Defaults to /var/backups/local/.
# [*mysql_user*]
#   MySQL user with rights to dump the specified databases. Defaults to 'root'.
# [*mysql_passwd*]
#   Password for the above user.
# [*hour*]
#   Hour(s) when mysqldump gets run. Defaults to 01.
# [*minute*]
#   Minute(s) when mysqldump gets run. Defaults to 10.
# [*weekday*]
#   Weekday(s) when mysqldump gets run. Defaults to * (all weekdays).
#
# == Examples
#
# }
#
define xtrabackup::backup
(
    $status = 'present',
    $databases = ['all'],
    $incremental = false,
    $output_dir = '/var/backups/local',
    $mysql_user = 'root',
    $mysql_passwd,
    $hour = '01',
    $minute = '10',
    $weekday = '*',
)
{

    include xtrabackup

    # Get string representations of the database array
    $databases_string = join($databases, ' ')
    $databases_identifier = join($databases, '_and_')

    if $databases_string == 'all' {
        $base_command = "innobackupex --user=${mysql_user} --password=${mysql_passwd}"
    } else {
        $base_command = "innobackupex --user=${mysql_user} --password=${mysql_passwd} --databases=\"${databases_string}\""
    }

    if $incremental == true {
        $cron_command = "${base_command} --incremental ${output_dir} --incremental-basedir=\"${output_dir}/latest_full_backup_of_${databases_identifier}\""
    } else {
        $cron_command = "${base_command} \"${output_dir}/latest_full_backup_of_${databases_identifier}\" --no-timestamp"
    }

    cron { "xtrabackup-backup-${title}-cron":
        ensure => $status,
        command => $cron_command,
        user => root,
        hour => $hour,
        minute => $minute,
        weekday => $weekday,
        require => Class['localbackups'],
    }
}
