xtrabackup
==========

A puppet module for managing xtrabackup-based backups.

# Module usage

Add a daily xtrabackup cronjob:

    include ::xtrabackup
    
    ::xtrabackup::backup { 'daily':
      ensure            => present,
      databases         => [ 'all' ],
      incremental       => true,
      use_root_defaults => true,
      hour              => '23',
      minute            => '50',
      weekday           => '*',
      email             => 'monitoring@example.org',
    }

For details see [init.pp](manifests/init.pp) and [backup.pp](manifests/backup.pp).
