FROM registry.access.redhat.com/ubi8/s2i-base
RUN yum install -y sudo
RUN useradd -ms /bin/bash asis && echo "asis:passw0rd" | chpasswd
RUN usermod -aG wheel asis
USER asis
WORKDIR /home/asis
RUN git clone https://github.com/parthsl/schbench && cd schbench/schbench && make
#CMD ["schbench/schbench/schbench"]
CMD [ "sleep", "infinity" ]
