puppet-splunk-forwarder
=======================

Puppet modules that install and configure Splunk forwarder on windows or Ubuntu ,working with a deployment server


How to use it
=============

```
  class {'splunk':
  
  # this hash behave as your inputs.conf file
  # each member of the hash will be trasnformed as a new stanza, and the key value under them will be the variables of the stanza
        input_hash   => { 'monitor://C:\temp\log*.log' => {
                       disabled   => 'false',
                       index      => 'main',
                       sourcetype => 'testing1'},
                     'monitor://C:\temp\log*.txt' => {
                       disabled   => 'false',
                       index      => 'main',
                       sourcetype => 'testing2'},
                     'WinEventLog://Application' => {
                       disabled  => '0',
                       whitelist => '4212'},
    },
    deployment_server => '<deployment server ip>',
    #default is set to 9997
    deployment_port => 'xxxx',
    #default is set to 8089
    receiving_port => 'xxxx',
    source_file => "<the complete path to Splunk installation file >",
  }

 ```
