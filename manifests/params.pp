# == Class: smokeping::params
#
# This class manages Smokeping parameters.
#

class smokeping::params {
    $version            = 'present'
    $enable             = true
    $start              = true

    $master_url         = 'http://somewhere/cgi-bin/smokeping.cgi'
    $shared_secret      = '/etc/smokeping/slavesecrets.conf'
    $slave_secrets      = '/etc/smokeping/smokeping_secrets'
    $slave_name         = $facts['fqdn']
    $slave_dir          = '/etc/smokeping/config.d/slaves.d'
    $slave_location     = ''
    $slave_display_name = ''
    $slave_color        = ''
    $master_name        = 'default'

    $owner              = 'Peter Random'
    $contact            = 'root@localhost'
    $mailhost           = 'my.mail.host'
    $syslogfacility     = 'local0'
    $syslogpriority     = 'info'
    $cgi_remark_top     = 'Welcome to the SmokePing website of xxx Company. Here you will learn all about the latency of our network.'
    $cgi_title_top      = 'Network Latency Grapher'

    $default_probe      = 'FPing'
    $alerts_to          = 'root@localhost'
    $alerts_from        = 'root@localhost'
    $alerts             = [ {
      name              => 'someloss',
      alert_type        => 'loss',
      pattern           => '>0%,*12*,>0%,*12*,>0%',
      edgetrigger       => false,
      comment           => 'loss 3 times in a row',
      } ]

    # /etc/smokeping appears to be generally consistent cross-platform
    $targets_dir        = '/etc/smokeping/config.d/targets.d'
    $targets            = {}
    $path_smokemail     = '/etc/smokeping/smokemail'
    $path_tmail         = '/etc/smokeping/tmail'
    $manage_apache      = false
    $manage_firewall    = false
    $manage_selinux     = false
    $servername         = $::fqdn

    # The major cross-platform differences consist of user account variations
    # and where files reside on disk:
    if $::osfamily == 'Debian' {

      $mode               = 'master'
      $daemon_user        = 'smokeping'
      $daemon_group       = 'smokeping'
      $path_sendmail      = '/usr/sbin/sendmail'
      $path_imgcache      = '/var/cache/smokeping/images'
      $path_imgurl        = '../smokeping/images'
      $path_datadir       = '/var/lib/smokeping'
      $path_piddir        = '/var/run/smokeping'
      $probes             = [ { name => 'FPing', binary => '/usr/bin/fping', step => '300' } ]

      $cgiurl             = 'http://some.url/smokeping.cgi'
      $webserver_user     = 'www-data'
      $webserver_group    = 'www-data'

      $package_perldoc    = 'perl-doc'

    } elsif $::osfamily == 'RedHat' or $::operatingsystem == 'amazon' {

      # The Fedora RPM seems to run in foreground mode as root. This probably
      # isn't the best decision, but we shouldn't try and adjust how the OS
      # package runs, rather feedback/commits should go upstream to the OS
      # distributor/packager.
      #
      # Note that many thirdparty Smokeping RPMs for EL tend to be rebuilds of
      # the Fedora one, so best to fix in Fedora first, then tackle the other
      # third party repositories.
      $mode               = 'standalone'
      $daemon_user        = 'root'
      $daemon_group       = 'root'

      $path_sendmail      = '/usr/sbin/sendmail'
      $path_imgcache      = '/var/lib/smokeping/images'
      $path_imgurl        = '/smokeping/images'
      $probes             = [ { name => 'FPing', binary => '/usr/sbin/fping', step => '300' } ]
      $path_datadir       = '/var/lib/smokeping/rrd'
      $path_piddir        = '/var/run/smokeping'

      $cgiurl             = 'http://localhost/smokeping/sm.cgi'
      $webserver_user     = 'apache'
      $webserver_group    = 'apache'

      $package_perldoc    = 'perl-Pod-Perldoc'
    }


}
