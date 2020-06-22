FROM registry.access.redhat.com/ubi8/s2i-base

RUN yum install -y sudo && \
    adduser user && \
    echo "user ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user

#RUN su - user -c "touch mine"
USER user
CMD ["/bin/bash"]

