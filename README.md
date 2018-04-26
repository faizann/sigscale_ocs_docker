# Overview

This is a simple docker file to run sigscale ocs. Nothing is tested except GUI. Use at your own risk.


# Create Docker image using this command
`docker build -t ocs:1.0 --build-arg ocs_ver=v3.0.4 .`


# Run the docker using this command to directly attach to the erlang shell.
`docker run -it -h ocsnode --name ocs -p8080:8080 ocs:1.0`
or use *-d* switch to in docker run to detach and attach later to the shell

# To attach to erlang shell if run as deamon with -d switch
`docker exec -it ocs /bin/bash`
once inside the docker container connect to the erlang node
`erl -sname ocs1 -remsh ocs@ocsnode -setcookie ocsme`

You will attach to erlang shell.
To see if all ran successfully check with this command on erlang shell
```
application:loaded_applications().
[{compiler,"ERTS  CXC 138 10","7.1.5"},
 {public_key,"Public key infrastructure","1.5.2"},
 {ssl,"Erlang/OTP SSL application","8.2.5"},
 {mochiweb,"MochiMedia Web Server","2.17.0"},
 {ocs,"SigScale Online Charging System (OCS)","3.0.25"},
 {mnesia,"MNESIA  CXC 138 12","4.15.3"},
 {radius,"RADIUS Protocol Stack","1.4.4"},
 {sasl,"SASL  CXC 138 11","3.1.1"},
 {xmerl,"XML parser","1.3.16"},
 {syntax_tools,"Syntax tools","2.1.4"},
 {crypto,"CRYPTO","4.2.1"},
 {inets,"INETS  CXC 138 49","6.5"},
 {diameter,"Diameter protocol","2.1.4"},
 {stdlib,"ERTS  CXC 138 10","3.4.5"},
 {asn1,"The Erlang ASN1 compiler version 5.0.5","5.0.5"},
 {kernel,"ERTS  CXC 138 10","5.4.3"}]
```

# Web GUI
Browse to localhost:8080 on your machine and you should see the gui. the deafult user/pass is admin/admin

# DB directory mounting. 
If we don't want to lose the DB that is created then mount the db directory like this
`docker run -it --name ocs -p8080:8080 -v $(pwd)/db:/opt/ocs/db ocs:1.0`

# Other notes
* The docker image disables the SSL support for HTTP and sys.config should be updated for that accordingly.
* The diameter and radius is not tested yet. Only GUI was tried out
