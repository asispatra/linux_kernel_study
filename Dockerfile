FROM registry.access.redhat.com/ubi8/s2i-base
#RUN yum install sudo -y
RUN useradd -ms /bin/bash asis
#RUN usermod -aG wheel asis
USER asis
WORKDIR /home/asis
RUN git clone https://github.com/parthsl/schbench && cd schbench/schbench && make
CMD ["schbench/schbench/schbench"]

