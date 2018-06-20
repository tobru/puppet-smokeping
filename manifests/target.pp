# === Parameters
# [*pagetitle*]
#   Title. If empty, menu will be used as Title
#
# [*menu*]
#   Menu name.
#
# [*hierarchy_level*]
#   Level of this target on the menu hierarchy. (Default: 1)
#
# [*hierarchy_parent*]
#   If hierarchy_level > 1, this specifies the parent
#
# [*probe*]
#   Which probe to use.
#
# [*host*]
#   Target host name/IP.
#
# [*alerts*]
#   Array of Alerts to apply to this target
#
# [*slaves*]
#   Array of slaves on which to run this target
#
# [*nomasterpoll*]
#   Disable data-polling from master
#
# [*remark*]
#   Remark displayed on Website
#
define smokeping::target (
  String $pagetitle,
  String $menu,
  String $probe,
  String $host,
  String $hierarchy_parent = '',
  String $remark           = '',
  Integer $hierarchy_level = 1,
  Array $alerts            = [],
  Array $slaves            = [],
  Boolean $nomasterpoll    = false,
  Hash $options            = {},
) {

    assert_type(Pattern[/^[-_0-9a-zA-Z]+$/], $name)

    $filename = "${smokeping::targets_dir}/${hierarchy_level}-${name}"
    concat { $filename:
        owner   => root,
        group   => root,
        mode    => '0644',
        require => File[$::smokeping::targets_dir],
        notify  => Class['smokeping::service'],
    }
    concat::fragment { "target-definition-${hierarchy_level}-${name}":
        target  => $filename,
        order   => 10,
        content => template('smokeping/target.erb'),
    }

    # Top level
    if $hierarchy_level == 1 {
        concat::fragment { "target-${hierarchy_level}-${name}":
            target  => '/etc/smokeping/config.d/Targets',
            order   => '11',
            content => "@include ${filename}\n",
        }
        } else {
            #all other levels
            if $hierarchy_parent == '' {
                fail('hierarchy_parent has to be specified for levels > 1')
            }
            $parent_level = $hierarchy_level - 1
            $parent_filename = "${smokeping::targets_dir}/${parent_level}-${hierarchy_parent}"
            concat::fragment { "target-${parent_level}-${hierarchy_parent}-${name}":
                target  => $parent_filename,
                order   => '11',
                content => "@include ${filename}\n",
            }
        }

}
