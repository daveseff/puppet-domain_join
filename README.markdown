[![Build Status](https://travis-ci.org/rnelson0/puppet-domain_join.png?branch=master)](https://travis-ci.org/rnelson0/puppet-domain_join)
[![Puppet Forge](http://img.shields.io/puppetforge/v/rnelson0/domain_join.svg)](https://forge.puppetlabs.com/rnelson0/domain_join)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/rnelson0/domain_join.svg)](https://forge.puppetlabs.com/rnelson0/domain_join)
[![Stories in Ready](https://badge.waffle.io/rnelson0/puppet-domain_join.svg?label=ready&title=Ready)](http://waffle.io/rnelson0/puppet-modules)
[![Stories In Progress](https://badge.waffle.io/rnelson0/puppet-domain_join.svg?label=in progress&title=In Progress)](http://waffle.io/rnelson0/puppet-modules)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with domain_join](#setup)
    * [What domain_join affects](#what-domain_join-affects)
    * [Beginning with domain_join](#beginning-with-domain_join)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Limitations - OS compatibility, etc.](#limitations)

## Overview

Provide the most minimal configuration required to allow a Linux node to join a Windows domain.

## Module Description

This module is intended for the lazy Linux admin who wants their Linux nodes to join a Windows domain without needing to manage the components. Rather than managing SSSD, Samba, and Kerberos, just manage "the ability to join a domain"!

Unfortunately, if you want to manage those services separately, this module may not be for you. You may still manage the domain join script and DNS settings only, if you like. [planned]

## Setup

### What domain_join affects

* DNS resolution through `/etc/resolv.conf`
* SSSD, Samba, and Kerberos configs (`/etc/sssd/sssd.conf`, `/etc/samba/smb.conf`, `/etc/krb5.conf`)
* A domain join shell script at `/usr/local/bin/domain_join`, that includes credentials used to join the domain.
    * It is *highly* recommended that you follow the [Principle of Least Privilege](https://en.wikipedia.org/wiki/Principle_of_least_privilegehttps://en.wikipedia.org/wiki/Principle_of_least_privilege) and do *not* use a Domain Admin account or similar.

### Beginning with domain_join

    # Without hiera
    class { 'domain_join':
      domain_fqdn => 'example.com',
      domain_shortname => 'example',
      ad_dns           => ['10.0.0.1', '10.0.0.2'],
      register_account => 'domainjoin',
      register_password => 'Sup4rS3krEt',
      additional_search_domains => ['web.example.com', 'b2b.example.com'],
    }

    # With Hiera
    # Manifest:
    include domain_join
    
    # Hiera yaml:
    ---
    domain_join::domain_fqdn: example.com
    domain_join::domain_shortname: example
    domain_join::ad_dns:
      - 10.0.0.1
      - 10.0.0.2
    domain_join::register_account: domainjoin
    domain_join::register_password: 'Sup4rS3krEt'
    domain_join::additional_search_domains:
      - web.example.com
      - b2b.example.com

## Usage

You may follow the above reference for simple domain joins. If you wish to only manage the domain_join script, ... [planned]

## Limitations

This module will most likely be incompatible when used in the same catalog as any module that directly manages sssd, samba, or kerberos packages or configs. See the compatibility tab or [metadata.json](metadata.json) for tested OS support.
