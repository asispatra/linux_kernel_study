FROM registry.redhat.io/rhel8/httpd-24
RUN yum install sudo -y
RUN usermod -aG wheel default
USER default
CMD ["/usr/bin/run-httpd"]

