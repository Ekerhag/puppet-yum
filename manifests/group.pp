# Define: yum::group
#
# This definition installs or removes yum package group.
#
# Parameters:
#   [*ensure*]   - specifies if package group should be
#                  present (installed) or absent (purged)
#   [*timeout*]  - exec timeout for yum groupinstall command
#
# Actions:
#
# Requires:
#   RPM based system
#
# Sample usage:
#   yum::group { 'X Window System':
#     ensure  => 'present',
#   }
#
define yum::group (
  Enum['present', 'installed', 'absent', 'purged'] $ensure  = 'present',
  Optional[Integer]                                $timeout = undef,
) {
  Exec {
    path        => '/bin:/usr/bin:/sbin:/usr/sbin',
    environment => 'LC_ALL=C',
  }

  case $ensure {
    'present', 'installed', default: {
      exec { "yum-groupinstall-${name}":
        command => "yum -y groupinstall '${name}'",
        unless  => "yum grouplist hidden '${name}' | egrep -i '^Installed.+Groups:$'",
        timeout => $timeout,
      }
      if ($facts['os']['name'] == 'CentOS' and $facts['os']['release']['major'] == '7') {
        exec { "yum-groupinstall-mark-${name}":
          command => "yum groups mark install '${name}'",
          unless  => "yum grouplist hidden '${name}' | egrep -i '^Installed.+Groups:$'",
          timeout => $timeout,
        }
      }
    }

    'absent', 'purged': {
      exec { "yum-groupremove-${name}":
        command => "yum -y groupremove '${name}'",
        onlyif  => "yum grouplist hidden '${name}' | egrep -i '^Installed.+Groups:$'",
        timeout => $timeout,
      }
    }
  }
}
