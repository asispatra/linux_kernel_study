FROM registry.access.redhat.com/ubi8/s2i-base
RUN useradd -ms /bin/bash asis
USER asis
WORKDIR /home/asis
CMD ["echo", "Hello World!"]
