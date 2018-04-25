#!/bin/sh
INITDB=0
if [ -d /opt/ocs/db ]; then
    if [ ! "$(ls -A /opt/ocs/db)" ]; then
        INITDB=1
    fi
else
    INITDB=1
fi

if [ $INITDB -eq 1 ]; then 
    echo "Initialising DB"
    erl -pa ebin ../lib/mochiweb-2.17.0/ebin ../lib/radius-1.4.4/ebin -sname ocs -config sys -s ocs_app install -s init stop
fi
erl -pa ebin ../lib/mochiweb-2.17.0/ebin ../lib/radius-1.4.4/ebin -sname ocs -config sys -eval 'systools:make_script("ocs",[local])' -s init stop
#erl -kernel inet_dist_listen_min 9001 inet_dist_listen_max 9005 -pa ebin ../lib/mochiweb-2.17.0/ebin ../lib/radius-1.4.4/ebin -boot ocs -sname ocs -setcookie ocsme -config sys
erl -pa ebin ../lib/mochiweb-2.17.0/ebin ../lib/radius-1.4.4/ebin -boot ocs -sname ocs -setcookie ocsme -config sys
