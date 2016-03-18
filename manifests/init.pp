# Add configuration and scripts for adding a device to a domain
class domain_join (
  $domain_fqdn,                       # FQDN of the domain, example: example.com
  $domain_shortname,                  # Short name/alias of the domain, example: example
  $ad_dns,                            # Array of DNS servers for the domain, example: ['1.2.3.4', '5.6.7.8']
  $register_account,                  # Account for registering with the domain, example: Administrator
  $register_password,                 # Password for the registration domain, example: password
  $additional_search_domains = undef, # List of additional domains to search in resolv.conf, example: subdomain.example.com
) {
  $required_packages = [
    'oddjob-mkhomedir',
    'krb5-workstation',
    'krb5-libs',
    'sssd-common',
    'sssd-ad', 
    'samba-common'
  ]
  package { $required_packages:
    ensure => present,
  }

  # Most of the packages above require a configuration file, but after the corresponding package. We can simplify
  # the requirement to be all packages prior to our files
  Package<| |> -> File<| tag == 'domain_join' |>

  file  {'/etc/resolv.conf':
    ensure => present,
    content => template('domain_join/resolv.conf.erb'),
  }
  file {'/etc/krb5.conf':
    ensure => present,
    content => template('domain_join/krb5.conf.erb'),
  }
  file {'/etc/samba/smb.conf':
    ensure => present,
    content => template('domain_join/smb.conf.erb'),
  }
  file {'/etc/sssd/sssd.conf':
    ensure => present,
    content => template('domain_join/sssd.conf.erb'),
  }

  # Finally we need a script to join the domain. This should be called during provisioning
  # Only root should be able to call this
  file {'/usr/local/bin/domain-join':
    ensure => present,
    content => template('domain_join/domain_join.erb'),
    mode => '0700',
  }
}
