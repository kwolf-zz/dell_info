#Puppet dell_info

##Overview

This puppet module adds custom facts aquired by querying https://api.dell.com/.

##Module Description

We use this to track the age of our mission critical production servers. 

Facts are cached for seven days by default.

Custom facts added, may very based on your warranty details:

```
      purchase_date => 2011-04-13
      server_age => 2.16 years
      warranty => true
      warranty0_desc => Silver Premium Support
      warranty0_expires => 2014-04-14
      warranty0_type => INITIAL
      warranty1_desc => Next Business Day Support
      warranty1_expires => 2014-04-14
      warranty1_type => EXTENDED
      warranty2_desc => Next Business Day Support
      warranty2_expires => 2012-04-14
      warranty2_type => INITIAL
```

The _warranty_ fact should be set to _warranty => true_ if any warranties are greater than the current date, and _warranty => false_ if all warranties have expired.

##Limitations

* Currently dell_info only supports Linux based operating systems.  We've used it on CentOS, RedHat, Ubuntu and Proxmox (Debian).
** Would take much to make this work on Windows.  Right now I'm using curl instead of net http. 
* Only runs on Dell bare metal servers.
* Will only query Dell for hardware based servers which have serial numbers Facter can see.

##Author

Kevin Wolf
kwolf72@gmail.com

##Support

Please log tickets and issues at our [dell_info](https://github.com/kwolf/dell_info/issues)

##Release notes

### 0.0.1

Initial release of dell_info.  Works for us at this point.


