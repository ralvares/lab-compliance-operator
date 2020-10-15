FROM quay.io/openshifthomeroom/workshop-dashboard:5.0.1

USER root

COPY . /tmp/src

RUN rm -rf /tmp/src/.git* && \
    chown -R 1001 /tmp/src && \
    chgrp -R 0 /tmp/src && \
    chmod -R g+w /tmp/src && \
    cp -rf /tmp/src/bin/oc-compliance /usr/local/bin && \
    yum update -y && \
    yum install -y python3 mariadb source-to-image tree python2-httpie procps-ng cmake dbus-devel GConf2-devel libacl-devel libblkid-devel libcap-devel libcurl-devel libgcrypt-devel libselinux-devel libxml2-devel libxslt-devel libattr-devel make openldap-devel pcre-devel perl-XML-Parser perl-XML-XPath perl-devel python-devel rpm-devel swig bzip2-devel gcc-c++ libyaml-devel && \
    yum clean all && \
    rm -rf /var/cache/yum && \ 
    pip install yq && \
    wget https://github.com/OpenSCAP/openscap/releases/download/1.3.4/openscap-1.3.4.tar.gz && \
    tar -xzvf openscap-1.3.4.tar.gz && cd openscap-1.3.4 && mkdir -p build && cd build && cmake ../ && make && make install && cd && rm -rf openscap-1.3.4.tar.gz openscap-1.3.4 && \
    cp -rf  /usr/local/bin/oc-4.6 /opt/workshop/bin/oc

ENV ENABLE_CONSOLE=false

USER 1001

RUN /usr/libexec/s2i/assemble
