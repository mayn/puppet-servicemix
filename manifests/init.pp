# == Class: servicemix
#
# This class installs Servicemix
#
# === Parameters
#
class servicemix (
  $version = $::servicemix::params::version,
  $source = $::servicemix::params::source,
  $path = $::servicemix::params::path,
  $tmpdir = $::servicemix::params::tmpdir

) inherits servicemix::params {
class { 'staging':
  path  => "${tmpdir}",
}

if $version == undef {
    fail("A servicemix version needs to be specified")
  }
validate_re($version, '^\d+\.\d+\.\d$',  "Servicemix version '${version}' does not follow expected naming convention")


validate_absolute_path($tmpdir)

#build target url if one wasn't provided, appending version info
if $path {
  $install_path = $path
} else {
  $install_path = "${$::servicemix::params::path}-${$version}"

}
validate_string($install_path)

#validate_absolute_path("${install_path}")

#build source url if one wasn't provided
if $source {
    $source_uri = $source
} else {
    if $version =~ /^(\d+)\..*/ {
        $source_uri = "http://archive.apache.org/dist/servicemix/servicemix-${$1}/${$version}/apache-servicemix-${$version}.zip"
    }else{
      fail("Unable to determine major revision from servicemix version '${version}'")
    }
}
validate_string($source)

#extract file name from source i.e apache-servicemix-4.tar.gz
#
    $source_archive = staging_parse($source_uri, "filename")
validate_string($source_archive)




staging::file { "${source_archive}":
  source => "${source_uri}",
  target => "${tmpdir}/${source_archive}",
}

staging::extract { "${source_archive}":
    source => "${tmpdir}/${source_archive}",
  target => staging_parse($install_path, "parent"),
  creates => "${install_path}",
  onlyif => "test -d ${install_path}",
  require => Staging::File["${source_archive}"],
}


}
