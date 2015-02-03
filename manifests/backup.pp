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
#   An array containing the names of databases to back up. This should be left 
#   to it's default value, ['all'], so that all databases are backed up. Change 
#   this only if you're sure you can handle the fairly complex process of 
#   restoring from partial backups with innobackupex.
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
# [*use_root_defaults*]
#   Defines whether to load /root/.my.cnf or not. This is intended to help 
#   prevent mysql passwords from leaking out in cron's emails if xtrabackup 
#   errors out for whatever reason. Set this parameter to 'yes' to use this 
#   feature and make sure that /root/.my.cnf exists on the target nodes (e.g. by 
#   including the mysql::config::rootopts class). The default value is 'no', 
#   which means that the $mysql_user and $mysql_passwd will be used for 
#   authentication.
# [*hour*]
#   Hour(s) when xtrabackup gets run. Defaults to 01.
# [*minute*]
#   Minute(s) when xtrabackup gets run. Defaults to 10.
# [*weekday*]
#   Weekday(s) when xtrabackup gets run. Defaults to * (all weekdays).
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
    $mysql_passwd = '',
    $use_root_defaults = 'no',
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

    if $use_root_defaults == 'yes' {
        $auth_string = "--defaults-extra-file=/root/.my.cnf"
    } else {
        $auth_string = "--user=${mysql_user} --password=\"${mysql_passwd}\""
    }

    if $databases_string == 'all' {
        $base_command = "innobackupex ${auth_string}"
    } else {
        $base_command = "innobackupex ${auth_string} --databases=\"${databases_string}\""
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
