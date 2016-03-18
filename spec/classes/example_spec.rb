require 'spec_helper'

describe 'domain_join' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "domain_join class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('domain_join::params') }
          it { is_expected.to contain_class('domain_join::install').that_comes_before('domain_join::config') }
          it { is_expected.to contain_class('domain_join::config') }
          it { is_expected.to contain_class('domain_join::service').that_subscribes_to('domain_join::config') }

          it { is_expected.to contain_service('domain_join') }
          it { is_expected.to contain_package('domain_join').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'domain_join class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('domain_join') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
