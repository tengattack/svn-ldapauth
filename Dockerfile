FROM ubuntu:18.04

RUN apt update -y \
    && apt install -y subversion libsasl2-modules-ldap sasl2-bin vim ca-certificates python python-setuptools python-ldap cron \
    && python /usr/lib/python2.7/dist-packages/easy_install.py pypinyin \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /data/svn

WORKDIR /data/svn

RUN sed -i -e "s/START=no/START=yes/" \
    -e "s/MECHANISMS=\"pam\"/MECHANISMS=\"ldap\"/" /etc/default/saslauthd \
    && echo '5 */1 * * * root python /usr/local/bin/sync_ldap_groups_to_svn_authz.py -c /etc/saslauthd.conf -g "objectClass=organizationalUnit" -i "sAMAccountName" -z /data/svn/authz -r /data/svn -v > /proc/1/fd/1 2>/proc/1/fd/2' >> /etc/crontab

#COPY saslauthd.conf /etc/saslauthd.conf
#COPY svnserve.conf conf/svnserve.conf
ADD svnfiles.tar /

EXPOSE 3690

CMD ["/entrypoint.sh"]
