#!/bin/bash

# Read and prepare environment and config

notification_email=${SET_NOTIFICATION_EMAIL:=root@localhost}
smtp_server=${SET_SMTP_SERVER_URL:=smtp://127.0.0.1}
smtp_pass=${SET_SMTP_PASS:=nopass}
email_from=${SET_EMAIL_FROM:=certspotter@localhost}
email_subject=${SET_EMAIL_SUBJ:=CertSpotter Report}
sleep_time=${SET_SLEEP_TIME:=1h}
watch_list=${SET_WATCHLIST_CONTENT:=}
certspotter_arguments=${SET_CERTSPOT_ARGS:=}
muttrc_file=${SET_MUTTRC_FILE:=/root/.muttrc}
mode=${SET_MODE:=daemon}

workdir=/certspotter/

# Set watchlist
if [[ $watch_list != "" ]] ; then
    echo "$watch_list" | tr ";" "\n" > $workdir/watchlist
fi

if ! [ -f $workdir/watchlist ] ; then
    echo "No watchlist, you have to create watchlist"
    echo "Set environment variable or use volume mount or configmap"
    exit 1
fi

echo "set from = \"$email_from\"" > /root/.muttrc
echo "set smtp_url = \"$smtp_server\"" >> /root/.muttrc
echo "set smtp_pass = \"$smtp_pass\"" >> /root/.muttrc
echo "set realname = \"CertSpotter\"" >> /root/.muttrc

# Report options
echo "Environment"
env
echo "Using following settings"
echo "Email: $notification_email"
echo "Sleep Time: $sleep_time"
echo "Watchlist content:"
cat $workdir/watchlist
echo "Running command:"
echo " + certspotter -watchlist $workdir/watchlist -state_dir $workdir $certspotter_arguments"

while [ 1 = 1 ] ; do
    
    set -e
    echo "$(date) Running certspotter"
    output=$(certspotter -watchlist $workdir/watchlist -state_dir $workdir $certspotter_arguments)
    if [[ "$output" != "" ]] ; then
        # output to log stdout
        echo "$output" 
        # Email report
        echo "$output" |  mutt -F $muttrc_file -s "$email_subject" $notification_email
    fi

    if [[ "$mode" == "onetime" ]] ; then
        echo "$(date) certspotter done"
        exit 0
    fi

    echo "$(date) certspotter done, sleeping ($sleep_time)"
    sleep $sleep_time

done
