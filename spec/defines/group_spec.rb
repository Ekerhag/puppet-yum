require 'spec_helper'

describe 'yum::group' do
  context 'with no parameters on CentOS 7' do
    let(:title) { 'Core' }
    let(:facts) do
      {
        'os' => {
          'name'    => 'CentOS',
          'release' => {
            'major' => '7',
          },
        },
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_exec("yum-groupinstall-#{title}").with_command("yum -y groupinstall 'Core'") }
    it { is_expected.to contain_exec("yum-groupinstall-mark-#{title}").with_command("yum groups mark install 'Core'") }
  end

  context 'with no parameters' do
    let(:title) { 'Core' }

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_exec("yum-groupinstall-#{title}").with_command("yum -y groupinstall 'Core'") }
  end

  context 'when ensure is set to `absent`' do
    let(:title) { 'Core' }
    let(:params) { { ensure: 'absent' } }

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_exec("yum-groupremove-#{title}").with_command("yum -y groupremove 'Core'") }
  end

  context 'with a timeout specified' do
    let(:title) { 'Core' }
    let(:params) { { timeout: 30 } }

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_exec("yum-groupinstall-#{title}").with_timeout(30) }
  end
end
