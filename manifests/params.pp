#
# == Class: xtrabackup::params
#
# Defines some variables based on the operating system
#
class xtrabackup::params {

    include ::os::params

    case $::osfamily {
        'Debian': {
            $package_name = 'xtrabackup'
        }
        default: {
            fail("Unsupported operating system ${::osfamily}")
        }
    }
}
