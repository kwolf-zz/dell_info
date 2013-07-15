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

api.dell.com uses API keys.  When I wrote this there were three publically available on the internet.  This isn't a private key that's currently in the module.  In fact, I couldn't find a way to get a private key.

Based on this [blog article](http://ocdnix.wordpress.com/2013/02/28/pulling-warranty-details-from-api-dell-com/) about api.dell.com. 


##Limitations

* Currently dell_info only supports Linux based operating systems.  We've used it on CentOS, RedHat, Ubuntu and Proxmox (Debian).
** Wouldn't take much to make this work on Windows.  Right now I'm using curl instead of net http.  Also the cache directory would need to chnage. It's pretty Linux specific right now.
* Only runs on Dell bare metal servers.
* Will only query Dell for hardware based servers which have serial numbers Facter can see.

##Author

Kevin Wolf
kwolf72@gmail.com

##Support

Please log tickets and issues at the [github repository](https://github.com/kwolf/dell_info/issues)

##Release notes

### 1.0.1
* Forgot to increment the version number in the module file.

### 1.0.0

* Incrementing the release to scare away less People.  This has been working fine for us.

### 0.0.1

* Initial release of dell_info.  Works for us at this point.


