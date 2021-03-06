# Warp10 test

This repo aims to test the functionality of Warp10.

## How to run the Warp10 nodes

Clean the folder to be ready to run Warp10 with the command line : `./init_folders.sh`
Take care, the command will remove all the files not commited in git.

Start the 2 nodes with docker-compose up:

* node1 : Warp10: 10.0.0.101:8080  -  WarpStudio: 10.0.0.101:8081
* node2 : Warp10: 10.0.0.102:8080  -  WarpStudio: 10.0.0.102:8081

You can start only one warp10 with `docker up warp10-db1`.

Nodes are configured to share data with each other.

If docker-compose doesn't works, stop all running container, prune them, prune volumes and prune **networks**

## Inject data 

You can inject data with the followings:

```bash

SERVER=10.0.0.101:9080
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
        print "=" startTs + nbSec * 1000000 "// " cos( nbSec * 2 * pi / 21600 ) 
    }
}' | gzip -c | curl -v \
    -H 'Content-Type: application/gzip' -H 'X-Warp10-Token: writeTokenCI' -H 'Transfer-Encoding: chunked' \
    -X POST --data-binary @- \
    "http://$SERVER/api/v0/update"

```


## Play with data

You will find some WarpScript in `1_scripts_generated_values` folder.

The `2_scripts_scms` folder is for my personnal usage.


## Datalog test (redundancy)

On https://www.warp10.io/content/03_Documentation/02_Installation/10_Advanced/01_High_Availability_using_Datalog there is a description on how to configure the data replication

The test is done in dockers container.

The docker containers need w10-data-* to run.
The configuration of the containers are in these folders.




## Check data in Warp10

You can use WarpStudio on : http://10.0.0.101:9081/

Just configure the end-point in the configuration to go to http://10.0.0.101:9080/

