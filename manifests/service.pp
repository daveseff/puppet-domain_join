# == Class domain_join::service
#
# This class is meant to be called from domain_join.
# It ensure the service is running.
#
class domain_join::service {

  service { $::domain_join::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
