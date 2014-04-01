class servicemix::params {
  #General Settings
  $version= undef
  $source = undef

  case $::osfamily {

    'Debian':{
      $tmpdir  ="/tmp"
      $path = "/opt/apache-servicemix"

    }
    'Redhat':{
      $tmpdir  ="/tmp"
      $path = '/usr/local/apache-servicemix'

    }
    default: {
      fail("The ${module_name} module is not supported on an ${::operatingsystem} distribution.")
    }

  }

}