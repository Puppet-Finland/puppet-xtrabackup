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
    $databases = 'all',
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

    if $databases == 'all' {
        $base_command = "innobackupex --user=${mysql_user} --password=${mysql_passwd}"
    } else {
        $base_command = "innobackupex --user=${mysql_user} --password=${mysql_passwd} --databases=\"${databases}\""
    }

    if $incremental == true {
        $cron_command = "${base_command} --incremental ${output_dir} --incremental-basedir=${output_dir}/latest_full_backup"
    } else {
        $cron_command = "${base_command} ${output_dir}/latest_full_backup --no-timestamp"
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
