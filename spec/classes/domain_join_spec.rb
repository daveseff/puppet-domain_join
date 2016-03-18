require 'spec_helper'
describe 'domain_join', :type => :class do
  let :facts do
    {
      :id => 'root',
      :kernel => 'Linux',
      :osfamily => 'RedHat',
      :operatingsystem => 'RedHat',
      :operatingsystemrelease => '7.2',
      :operatingsystemmajrelease => '7',
      :concat_domain_joindir => '/dne',
      :puppetversion => '4.3.1',
      :sudoversion => '1.8.6p3',
      :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
  end

  context 'with defaults for all parameters' do
    it { is_expected.to create_class('domain_join') }
    it { is_expected.to contain_package('oddjob-mkhomedir') }
    it { is_expected.to contain_package('krb5-workstation') }
    it { is_expected.to contain_package('krb5-libs') }
    it { is_expected.to contain_package('sssd-common') }
    it { is_expected.to contain_package('sssd-ad') }
    it { is_expected.to contain_package('sssd-common') }
    it { is_expected.to contain_file('/etc/resolv.conf') }
    it { is_expected.to contain_file('/etc/krb5.conf') }
    it { is_expected.to contain_file('/etc/samba/smb.conf') }
    it { is_expected.to contain_file('/etc/sssd/sssd.conf') }
    it { is_expected.to contain_file('/usr/local/bin/domain-join') }
  end
end
