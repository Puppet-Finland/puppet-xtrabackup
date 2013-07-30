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
#   The directory where to output the files. Defaults to
#   $::xtrabackup::config::backup_dir.
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
# [*report_only_errors*]
#   Suppress all cron output except errors. This is useful for reducing the
#   amount of emails cron sends.
# [*email*]
#   Email address where notifications are sent. Defaults to top-scope variable
#   $::servermonitor.
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
    $output_dir = $::xtrabackup::config::backup_dir,
    $mysql_user = 'root',
    $mysql_passwd,
    $hour = '01',
    $minute = '10',
    $weekday = '*',
    $report_only_errors = 'true',
    $email = $::servermonitor
)
{

    include xtrabackup

    # Get string representations of the database array
    $databases_string = join($databases, ' ')
    $databases_identifier = join($databases, '_and_')

    # All these conditionals make this look fairly nasty. Suggestions for 
    # improvements are most welcome.
    if $databases_string == 'all' {
        $base_command = "innobackupex --user=${mysql_user} --password=\"${mysql_passwd}\""
    } else {
        $base_command = "innobackupex --user=${mysql_user} --password=\"${mysql_passwd}\" --databases=\"${databases_string}\""
    }

    if $incremental == true {
        $base_command_with_type = "rm -rf ${output_dir}/${databases_identifier}-incremental && ${base_command} --incremental ${output_dir}/${databases_identifier}-incremental --incremental-basedir=\"${output_dir}/${databases_identifier}-full\" --no-timestamp"
    } else {
        $base_command_with_type = "rm -rf ${output_dir}/${databases_identifier}-full && ${base_command} \"${output_dir}/${databases_identifier}-full\" --no-timestamp"
    }

    # Even non-error output goes into stderr, so a grep is necessary
    if $report_only_errors == 'true' {
        $cron_command = "${base_command_with_type} 2>&1|grep Error"
    } else {
        $cron_command = "${base_command_with_type} 2>&1"
    }

    cron { "xtrabackup-backup-${title}-cron":
        ensure => $status,
        command => $cron_command,
        user => root,
        hour => $hour,
        minute => $minute,
        weekday => $weekday,
        environment => "MAILTO=${email}",
        require => Class['localbackups'],
    }
}
