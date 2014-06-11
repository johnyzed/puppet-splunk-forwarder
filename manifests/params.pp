class splunk::params {
  
  $deployment_port = 9997 
  $receiving_port = 8089
  $launchsplunk = 0
  #$deployment_server = $splunk::init::deployment_server


  #$deployment_string = "${deployment_server}:${deployment_port}"

if $operatingsystem == 'windows' {

  $agreetolicense = 'Yes'
  $wineventlog_app_enable = 1
  $wineventlog_sec_enable = 1
  $wineventlog_sys_enable = 1
  $wineventlog_fwd_enable = 1
  $wineventlog_set_enable = 1
  $wmicheck_cputime = 1
  $wmicheck_localdisk = 1
  $wmicheck_freedisk = 1
  $wmicheck_memory = 1
  $installdir = 'C:\\Program Files\\SplunkUniversalForwarder'
  $service_name = 'splunkforwarder'
  $install_options = {
                        'INSTALL_DIR' => $installdir,
                        'AGREETOLICENSE' => $agreetolicense,
                        'WINEVENTLOG_APP_ENABLE' => $wineventlog_app_enable,
                        'WINEVENTLOG_SEC_ENABLE' => $wineventlog_sec_enable,
                        'WINEVENTLOG_SYS_ENABLE' => $wineventlog_sys_enable,
                        'WINEVENTLOG_FWD_ENABLE' => $wineventlog_fwd_enable,
                        'WINEVENTLOG_SET_ENABLE' => $wineventlog_set_enable,
                        'WMICHECK_CPUTIME'=> $wmicheck_cputime,
                        'WMICHECK_LOCALDISK'=> $wmicheck_localdisk,
                        'WMICHECK_FREEDISK'=> $wmicheck_freedisk,
                        'WMICHECK_MEMORY'=> $wmicheck_memory,
                        'LAUNCHSPLUNK'=> $launchsplunk,}
   $provider = 'windows'
   $service_require = Package['UniversalForwarder']
   $inputs_path = "${installdir}\\etc\\system\\local\\inputs.conf"
   $deploy_cwd = "${installdir}\\bin"

  }
 else {
  $installdir = '/opt/splunkforwarder/'
  $service_name = 'splunk'
  $install_options ={
                      'INSTALL_DIR' => $installdir,
                     }
  $provider = 'dpkg'
  $service_require = [Package['UniversalForwarder'],File['/etc/init.d/splunk']]
  $inputs_path = "${installdir}/etc/system/local/inputs.conf"
  $deploy_cwd = "${installdir}bin"
  $start_splunk_create = "${installdir}etc/licenses"
  $start_splunk_cmd = "${installdir}bin/splunk start --accept-license"
  $set_boot_cmd = "${installdir}bin/splunk enable boot-start"
 }
}