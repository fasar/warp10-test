#!/bin/bash
#
#  docker run --rm -it --net warp10-datalog-test_default --name warp10-inject-data --runtime runc -v $PWD:/data:ro fasar/jbake:latest '/bin/sh' '-c' /data/inject_data.sh
#
#

SERVER=10.0.0.101:8080
NB_DAYS=365

# Generate a Ramp
echo Injecting a Ramp signal in test.signal{signal=voltage,name=ramp}
echo "" | awk ' 
{
    # My system is in mico seconds.
    startTs = 1577836800000000 # Stat ts at 2020-01-01T00:00:00Z    
    oneDayInSec = 24 * 60 * 60
    durationInDays = '$NB_DAYS' * oneDayInSec

    # We insert 4 ramps in one day
    for (nbSec = 0; nbSec < durationInDays; nbSec++) 
    {
        value = startTs + nbSec * 1000000 "// test.signal{signal=voltage,name=realTime} " ( nbSec % (oneDayInSec / 4) ) / 100
        print "Sending: " value
        system("echo TOTO " value )
        system("curl -v -H \"X-Warp10-Token: writeTokenCI\" --data-ascii \"" value "\" \"http://'$SERVER'/api/v0/update\"")
        system("sleep 1")
    }
}' 
