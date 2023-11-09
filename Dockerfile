FROM registry.access.redhat.com/ubi9/python-39:latest

WORKDIR /opt/app-root/bin

USER 0

RUN echo "Installing pypiserver" && \
    pip install pypiserver python-pypi-mirror && \
    mkdir /opt/app-root/packages &&\ 
    chmod ugo+w,+t /opt/app-root/packages && \
    fix-permissions /opt/app-root -P

USER 1001

WORKDIR /opt/app-root/src