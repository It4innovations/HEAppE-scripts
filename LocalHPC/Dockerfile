FROM bitnami/minideb

RUN useradd -rm -d /home/heappeclient -s /bin/bash -g root -G sudo -u 1001 heappeclient
RUN echo 'heappeclient:pass' | chpasswd
WORKDIR /home/heappeclient

COPY .key_scripts/ ./.key_scripts/
COPY .local_hpc_scripts/ ./.local_hpc_scripts/
COPY .ssh/ ./.ssh/
RUN apt-get update && apt-get install -y openssh-server
RUN apt-get install jq -y
RUN echo "/home/heappeclient/heappetests/" >> ./.local_hpc_scripts/.heappeWorkDirInfo
RUN mkdir /home/heappeclient/heappetests/
RUN mkdir /home/heappeclient/heappetestsTemp/
RUN mkdir /var/run/sshd
RUN echo 'root:pass' | chpasswd

RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

RUN chown -R heappeclient: /home/heappeclient