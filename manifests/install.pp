# == Class domain_join::install
#
# This class is called from domain_join for install.
#
class domain_join::install {

  package { $::domain_join::package_name:
    ensure => present,
  }
}
