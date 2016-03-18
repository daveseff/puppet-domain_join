# Class: domain_join
# ===========================
#
# Full description of class domain_join here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class domain_join (
  $package_name = $::domain_join::params::package_name,
  $service_name = $::domain_join::params::service_name,
) inherits ::domain_join::params {

  # validate parameters here

  class { '::domain_join::install': } ->
  class { '::domain_join::config': } ~>
  class { '::domain_join::service': } ->
  Class['::domain_join']
}
