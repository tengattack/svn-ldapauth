#!/bin/sh

service saslauthd start
service cron start

/usr/bin/svnserve --foreground -d -r /data/svn --log-file=/data/svn/svn.log
