# == Class domain_join::params
#
# This class is meant to be called from domain_join.
# It sets variables according to platform.
#
class domain_join::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'domain_join'
      $service_name = 'domain_join'
    }
    'RedHat', 'Amazon': {
      $package_name = 'domain_join'
      $service_name = 'domain_join'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
