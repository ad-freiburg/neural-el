FROM ubuntu:18.04
LABEL maintainer="prange@cs.uni-freiburg.de"

ENV PYTHONIOENCODING=UTF-8

RUN apt-get update && apt-get install -y python3-pip vim
RUN python3 -m pip install --upgrade pip

# Install python packages
COPY ./ /home/
RUN pip3 install -r /home/requirements.txt
RUN python3 -m spacy download en_core_web_lg
# Enable Makefile target autocompletion
RUN echo "complete -W \"\`grep -oE '^[a-zA-Z0-9_.-]+:([^=]|$)' ?akefile | sed 's/[^a-zA-Z0-9_.-]*$//'\`\" make" >> ~/.bashrc

ENTRYPOINT /bin/bash
WORKDIR /home/

# docker build -t neural-el-gupta .
# docker run -it -v /nfs/students/natalie-prange/neural-el-data/neural-el_resources:/data:ro -v /nfs/students/natalie-prange/neural-el-data/results:/results neural-el-gupta