include_attribute 'golang'

# Installation/System attributes

default['docker']['arch'] =
  case node['kernel']['machine']
  when 'x86_64' then 'x86_64'
  # If Docker ever supports 32-bit or other architectures
  # when %r{i[3-6]86} then 'i386'
  else 'x86_64'
  end
default['docker']['group_members'] = []
default['docker']['init_type'] = value_for_platform(
  %w(amazon debian oracle) => {
    'default' => 'sysv'
  },
  %w(redhat centos) => {
    %w(6.0 6.1 6.2 6.3 6.4 6.5 6.6) => 'sysv',
    'default' => 'systemd'
  },
  %w(fedora) => {
    'default' => 'systemd'
  },
  %w(ubuntu) => {
    'default' => 'upstart'
  },
  'default' => 'upstart'
)
default['docker']['install_type'] = value_for_platform(
  %w(centos debian fedora mac_os_x redhat ubuntu amazon) => {
    'default' => 'package'
  },
  'default' => 'binary'
)
default['docker']['install_dir'] =
  case node['docker']['install_type']
  when 'binary' then '/usr/local/bin'
  when 'source' then node['go']['gobin']
  else '/usr/bin'
  end
default['docker']['ipv4_forward'] = true
default['docker']['ipv6_forward'] = true
default['docker']['logfile'] = nil
default['docker']['version'] = nil

# Actions: :warn, :fatal
default['docker']['alert_on_error_action'] = :fatal

## Binary installation attributes

default['docker']['binary']['dependency_packages'] = value_for_platform_family(
  'debian' => %w(procps xz-utils),
  'rhel' => %w(procps xz),
  'default' => %w()
)
default['docker']['binary']['version'] = node['docker']['version'] || 'latest'
default['docker']['binary']['checksum'] =
case node['kernel']['name']
when 'Darwin'
  case node['docker']['binary']['version']
  when '1.0.1' then 'b662e7718f0a8e23d2e819470a368f257e2bc46f76417712360de7def775e9d4'
  end
when 'Linux'
  case node['docker']['binary']['version']
  when '1.0.1' then '1d9aea20ec8e640ec9feb6757819ce01ca4d007f208979e3156ed687b809a75b'
  when '1.8.1' then '843f90f5001e87d639df82441342e6d4c53886c65f72a5cc4765a7ba3ad4fc57'
  end
end
default['docker']['binary']['url'] = "http://get.docker.io/builds/#{node['kernel']['name']}/#{node['docker']['arch']}/docker-#{node['docker']['binary']['version']}"

## Package installation attributes

default['docker']['package']['action'] = 'install'
default['docker']['package']['distribution'] = "#{node['platform']}-#{node['lsb']['codename']}"
default['docker']['package']['name'] = value_for_platform(
  'amazon' => {
    'default' => 'docker'
  },
  %w(centos redhat) => {
    %w(6.0 6.1 6.2 6.3 6.4 6.5 6.6) => 'docker-io',
    'default' => 'docker'
  },
  'fedora' => {
    'default' => 'docker-io'
  },
  'debian' => {
    'default' => 'docker-engine'
  },
  'mac_os_x' => {
    'default' => 'homebrew/binary/docker'
  },
  'ubuntu' => {
    'default' => 'docker-engine'
  },
  'default' => nil
)
default['docker']['package']['repo_url'] = value_for_platform(
  'debian' => {
    'default' => 'https://apt.dockerproject.org/repo'
  },
  'ubuntu' => {
    'default' => 'https://apt.dockerproject.org/repo'
  },
  'default' => nil
)
default['docker']['package']['repo_keyserver'] = 'p80.pool.sks-keyservers.net'
default['docker']['package']['repo_key'] = '58118E89F3A912897C070ADBF76221572C52609D'

## Source installation attributes

default['docker']['source']['ref'] = 'master'
default['docker']['source']['url'] = 'https://github.com/dotcloud/docker.git'

# Docker Daemon attributes

default['docker']['api_enable_cors'] = nil

# DEPRECATED: will be removed in chef-docker 1.0
default['docker']['bind_socket'] = nil
# DEPRECATED: will be removed in chef-docker 1.0
default['docker']['bind_uri'] = nil

default['docker']['bip'] = nil
default['docker']['bridge'] = nil
default['docker']['debug'] = nil
default['docker']['dns'] = nil
default['docker']['dns_search'] = nil
default['docker']['exec_driver'] = nil

# DEPRECATED: will be removed in chef-docker 1.0
default['docker']['virtualization_type'] = node['docker']['exec_driver']

default['docker']['graph'] = nil
default['docker']['group'] = nil

# DEPRECATED: Support for bind_socket/bind_uri
default['docker']['host'] =
  if node['docker']['bind_socket'] || node['docker']['bind_uri']
    Array(node['docker']['bind_socket']) + Array(node['docker']['bind_uri'])
  else
    'unix:///var/run/docker.sock'
  end
default['docker']['http_proxy'] = nil
default['docker']['icc'] = nil
default['docker']['insecure-registry'] = nil
default['docker']['ip'] = nil
default['docker']['iptables'] = nil
default['docker']['mtu'] = nil
default['docker']['no_proxy'] = nil
default['docker']['options'] = nil
default['docker']['pidfile'] = nil
default['docker']['ramdisk'] = false
default['docker']['registry-mirror'] = nil
default['docker']['selinux_enabled'] = nil
default['docker']['storage_driver'] = nil
default['docker']['storage_opt'] = nil

# DEPRECATED: will be removed in chef-docker 1.0
default['docker']['storage_type'] = node['docker']['storage_driver']

default['docker']['tls'] = nil
default['docker']['tlscacert'] = nil
default['docker']['tlscert'] = nil
default['docker']['tlskey'] = nil
default['docker']['tlsverify'] = nil
default['docker']['tmpdir'] = nil

# LWRP attributes

default['docker']['docker_daemon_timeout'] = 10

## docker_container attributes

default['docker']['container_cmd_timeout'] = 60
default['docker']['container_init_type'] = node['docker']['init_type']

## docker_image attributes

default['docker']['image_cmd_timeout'] = 300

## docker_registry attributes

default['docker']['registry_cmd_timeout'] = 60

# Other attributes

# DEPRECATED: will be removed in chef-docker 1.0
default['docker']['restart'] = false if node['docker']['container_init_type']
