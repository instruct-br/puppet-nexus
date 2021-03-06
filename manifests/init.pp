# Nexus class.
#
# This is a class to install and manage Nexus 3:
#
# @example Declaring the class
#   include nexus
#
# @param [String] user User that will execute Nexus and own its directories
# @param [String] group Group for Nexus user
# @param [String] temp_path Path where the file will be downloaded before extraction
# @param [String] install_path Path where the Nexus will be extracted
# @param [String] service_name Name for Nexus's service
# @param [String] service_provider Service provider
# @param [String] os_ext Extension for filename that depends on OS
# @param [String] major_version Nexus's major version
# @param [String] minor_version Nexus's minor version
# @param [String] revision Nexus revision
# @param [Integer] http_port Port to serve HTTP
# @param [Integer] https_port Port to serve HTTPS
# @param [String] java_xms The JVM minimum heap size. Default to '512M'
# @param [String] java_xmx The JVM maximum heap size. Default to '1200M'
# @param [String] java_max_direct_mem The JVM maximum direct memory size. Default to '2G'
# @param [String] listen_address IP address Nexus listen (same for http and https)
# @param [Boolean] enable_https Whether to enable HTTPS or not
# @param [String] https_keystore Path to the keystore.jks
# @param [String] https_keystore_password Password to access the keystore
# @param [Boolean] manage_java Whether this module will manage Java or not
# @param [String] java_distribution Java's desired distribution
#
class nexus (
  String $user,
  String $group,
  String $temp_path,
  String $install_path,
  String $data_path,
  String $service_name,
  String $service_provider,
  String $os_ext,
  String $major_version,
  String $minor_version,
  String $release_version,
  String $revision,
  Integer[1024,65535] $http_port,
  Integer[1024,65535] $https_port,
  String $listen_address,
  String $java_xms                = '512M',
  String $java_xmx                = '1200M',
  String $java_max_direct_mem     = '2G',
  Boolean $enable_https           = false,
  String $https_keystore          = '',
  String $https_keystore_password = 'changeme',
  Boolean $manage_java            = true,
  String $java_distribution       = 'jre'
) {

  $version = "nexus-${major_version}.${minor_version}.${release_version}-${revision}"
  $app_path = "${install_path}/${version}"
  $work_dir = "${data_path}/sonatype-work"

  include nexus::install
  include nexus::service
  include nexus::config

  if $nexus::manage_java {
    include nexus::java
    Class['nexus::java']
    -> Class['nexus::install']
  }

  Class['nexus::install']
    -> Class['nexus::config']
      ~> Class['nexus::service']

}
