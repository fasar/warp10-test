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
    print startTs"// test.signal{signal=voltage,name=ramp} 0.0"
    
    oneDayInSec = 24 * 60 * 60
    durationInDays = '$NB_DAYS' * oneDayInSec

    # We insert 4 ramps in one day
    for (nbSec = 1; nbSec < durationInDays; nbSec++) 
    {
        print "=" startTs + nbSec * 1000000 "// " nbSec % (oneDayInSec / 4) ".0"
    }
}' | gzip -c | curl -v \
    -H 'Content-Type: application/gzip' -H 'X-Warp10-Token: writeTokenCI' -H 'Transfer-Encoding: chunked' \
    -X POST --data-binary @- \
    "http://$SERVER/api/v0/update"



# Generate a sinusoid
echo Injecting a Sin signal in test.signal{signal=voltage,name=sin}
echo "" | awk ' 
{
    # My system is in mico seconds.
    startTs = 1577836800000000 # Stat ts at 2020-01-01T00:00:00Z
    print startTs"// test.signal{signal=voltage,name=sin} 0.0"
    
    oneDayInSec = 24 * 60 * 60
    durationInDays = '$NB_DAYS' * oneDayInSec
    pi = atan2(0, -1)

    # We insert 4 sin in one day
    for (nbSec = 1; nbSec < durationInDays; nbSec++) 
    {
        print "=" startTs + nbSec * 1000000 "// " sin( nbSec * 2 * pi / 21600 ) 
    }
}' | gzip -c | curl -v \
    -H 'Content-Type: application/gzip' -H 'X-Warp10-Token: writeTokenCI' -H 'Transfer-Encoding: chunked' \
    -X POST --data-binary @- \
    "http://$SERVER/api/v0/update"

# Generate a sinusoid
echo Injecting a Cos signal in test.signal{signal=voltage,name=cos}
echo "" | awk ' 
{
    # My system is in mico seconds.
    startTs = 1577836800000000 # Stat ts at 2020-01-01T00:00:00Z
    print startTs"// test.signal{signal=voltage,name=cos} 0.0"
    
    oneDayInSec = 24 * 60 * 60
    durationInDays = '$NB_DAYS' * oneDayInSec
    pi = atan2(0, -1)

    # We insert 4 sin in one day
    for (nbSec = 1; nbSec < durationInDays; nbSec++) 
    {
        print "=" startTs + nbSec * 1000000 "// " cos( (  nbSec * 2 * pi )/ 21600 ) 
    }
}' | gzip -c | curl -v \
    -H 'Content-Type: application/gzip' -H 'X-Warp10-Token: writeTokenCI' -H 'Transfer-Encoding: chunked' \
    -X POST --data-binary @- \
    "http://$SERVER/api/v0/update"
