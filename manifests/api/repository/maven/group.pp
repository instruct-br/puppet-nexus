# == Define: nexus::api::repository::maven::group
#
define nexus::api::repository::maven::group (
  Array[String] $members                               = [],
  String $blobstore_name                               = 'default',
  String $host                                         = $nexus::listen_address,
  Integer $port                                        = $nexus::http_port,
  String $user                                         = 'admin',
  String $password                                     = 'admin123',
) {

  file { "/tmp/repository-maven-${name}.json":
    ensure  => present,
    owner   => $nexus::user,
    group   => $nexus::group,
    content => epp('nexus/api/repository/maven/group.json.epp', {
      repository_name => $name,
      blobstore_name  => $blobstore_name,
      members         => $members,
    }),
  }

  nexus::api::script::add { "add-repository-maven-${name}-script":
    path             => "/tmp/repository-maven-${name}.json",
    script_name      => $name,
    host             => $host,
    port             => $port,
    user             => $user,
    password         => $password,
    run              => true,
    delete_after_run => true,
  }

}