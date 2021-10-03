FROM amazonlinux:2

# install
RUN amazon-linux-extras install python3.8 -y

# install devel
RUN yum install -y python38-devel 

RUN mkdir /home/deploy
RUN mkdir /home/deploy/python