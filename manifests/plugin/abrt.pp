# = Foreman Proxy Abrt plugin
#
# This class installs abrt plugin
#
# === Parameters:
#
# $group::                      group owner of the configuration file
#
# $enabled::                    enables/disables the plugin
#                               type:boolean
#
# $abrt_send_log_file::         Log file for the forwarding script.
#
# $spooldir::                   Directory where uReports are stored before they are sent
#
# $aggregate_reports::          Merge duplicate reports before sending
#
# $send_period::                Period (in seconds) after which collected reports are forwarded.
#                               Meaningful only if smart-proxy-abrt-send is run as a daemon (not from cron).
#                               type:integer
#
# $faf_server_url::             FAF server instance the reports will be forwarded to
#
# $faf_server_ssl_noverify::    Set to true if FAF server uses self-signed certificate
#                               type:boolean
#
# $faf_server_ssl_cert::        Enable client authentication to FAF server: set ssl certificate
#
# $faf_server_ssl_key::         Enable client authentication to FAF server: set ssl key
#
class foreman_proxy::plugin::abrt (
  $enabled                 = $::foreman_proxy::plugin::abrt::params::enabled,
  $group                   = $::foreman_proxy::plugin::abrt::params::group,
  $abrt_send_log_file      = $::foreman_proxy::plugin::abrt::params::abrt_send_log_file,
  $spooldir                = $::foreman_proxy::plugin::abrt::params::spooldir,
  $aggregate_reports       = $::foreman_proxy::plugin::abrt::params::aggregate_reports,
  $send_period             = $::foreman_proxy::plugin::abrt::params::send_period,
  $faf_server_url          = $::foreman_proxy::plugin::abrt::params::faf_server_url,
  $faf_server_ssl_noverify = $::foreman_proxy::plugin::abrt::params::faf_server_ssl_noverify,
  $faf_server_ssl_cert     = $::foreman_proxy::plugin::abrt::params::faf_server_ssl_cert,
  $faf_server_ssl_key      = $::foreman_proxy::plugin::abrt::params::faf_server_ssl_key,
  ) inherits foreman_proxy::plugin::abrt::params {
  validate_bool($enabled)
  validate_absolute_path($abrt_send_log_file)
  validate_absolute_path($spooldir)
  validate_bool($aggregate_reports)
  validate_bool($faf_server_ssl_noverify)
  $group_real = pick($group, $::foreman_proxy::user)
  validate_string($group_real)

  foreman_proxy::plugin { 'abrt': } ->
  file { '/etc/foreman-proxy/settings.d/abrt.yml':
    ensure  => file,
    content => template('foreman_proxy/plugin/abrt.yml.erb'),
    owner   => 'root',
    group   => $group_real,
    mode    => '0640',
  }
}
