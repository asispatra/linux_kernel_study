FROM registry.access.redhat.com/ubi8/s2i-base
RUN useradd -ms /bin/bash asis
USER asis
WORKDIR /home/asis
RUN git clone https://github.com/parthsl/schbench && cd schbench/schbench && make
CMD ["schbench/schbench/schbench"]
