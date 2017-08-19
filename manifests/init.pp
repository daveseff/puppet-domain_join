# Add configuration and scripts for adding a device to a domain
class domain_join (
  $domain_fqdn,                       # FQDN of the domain, example: example.com
  $domain_shortname,                  # Short name/alias of the domain, example: example
  $ad_dns,                            # Array of DNS servers for the domain, example: ['1.2.3.4', '5.6.7.8']
  $register_account,                  # Account for registering with the domain, example: Administrator
  $register_password,                 # Password for the registration domain, example: password
  $additional_search_domains = undef, # List of additional domains to search in resolv.conf, example: subdomain.example.com
  $manage_services = true,            # Whether or not the services are managed
  $manage_dns = false,                # Whether or not dns entries are managed
  $manage_resolver = true,            # Whether or not the resolver configuration is managed
  $manage_sssd = true,                # Whether or not sssd config is managed. If not, sssd.conf must be in the catalog elsewhere.
  $disable_smbv1 = true,              # Disable SMBv1, require SMBv2/3.
  $createcomputer = undef,            # Name of the container for the newly joined nodes. Optional.
  $create_ptr = true,                 # Create the PTR record in addition to the A record.
  $interface = 'eno16780032',         # The interface associated with the DNS entry. Default for EL7 VMs.
  $join_domain = true,                # set to false to just run configuration and not join the domain.
) {

  $service_packages_tmp = [
    'oddjob-mkhomedir',
    'krb5-workstation',
    'krb5-libs',
    'sssd-common',
    'sssd-ad',
    'sssd-tools',
    'ldb-tools',
    'samba-common',
  ]


  ## Since this is a RHEL-based module, we need to distinguish between RHEL 6 and 7
  ##   and then add 'samba-common-tools' package to the package list for RHEL 7 only
  if downcase( $facts['os']['family'] ) == 'redhat' {
    if $facts['os']['release']['major'] == '6' {
      $service_packages = $service_packages_tmp
    }
    if $facts['os']['release']['major'] == '7' {
      $service_packages = concat($service_packages_tmp, ['samba-common-tools'])
    }
  }

  if $manage_services {
    ensure_packages($service_packages, {'ensure' => 'present'})
    # The required packages contain a configuration file. Ensure our configuration file is added after the package.
    Package<| tag == 'domain_join' |> -> File<| tag == 'domain_join' |>

    file {'/etc/krb5.conf':
      ensure => present,
      content => template('domain_join/krb5.conf.erb'),
    }
    file {'/etc/samba/smb.conf':
      ensure => present,
      content => template('domain_join/smb.conf.erb'),
    }
    if $manage_sssd {
      file {'/etc/sssd/sssd.conf':
        ensure => present,
        content => template('domain_join/sssd.conf.erb'),
      }
    }
  }

  if $manage_resolver {
    file  {'/etc/resolv.conf':
      ensure => present,
      content => template('domain_join/resolv.conf.erb'),
    }
  }

  # Finally we need a script to join the domain. This should be called during provisioning
  # Only root should be able to call this
  file {'/usr/local/bin/domain-join':
    ensure => present,
    content => template('domain_join/domain_join.erb'),
    mode => '0700',
  }

  if $join_domain {
    exec { 'join the domain':
      command => '/usr/local/bin/domain-join -j',
      unless  => '/usr/local/bin/domain-join -q',
    }
  }

  if ($manage_services and $join_domain) {
    File['/etc/sssd/sssd.conf'] -> Exec['join the domain']
  }
}
