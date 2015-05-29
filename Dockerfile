# Dockerfile for the PDC's Endpoint service
#
# Base image
#
FROM phusion/passenger-ruby19


# Update system, install AuthSSH, Lynx and UnZip
#
ENV DEBIAN_FRONTEND noninteractive
RUN echo 'Dpkg::Options{ "--force-confdef"; "--force-confold" }' \
      >> /etc/apt/apt.conf.d/local
RUN apt-get update; \
    apt-get upgrade -y; \
    apt-get install -y \
      autossh \
      lynx \
      unzip


# Branch to use from GitHub
#
ENV BRANCH pdc-0.1.0


# Clone repo, assign to app
#
WORKDIR /app/
RUN git clone -b ${BRANCH} https://github.com/physiciansdatacollaborative/endpoint.git .
RUN mkdir -p /app/tmp/pids /app/util/files
RUN chown -R app:app /app/


# Configure Endpoint (run bundler as non-root)
#
RUN /usr/bin/gem install multipart-post
RUN /sbin/setuser app bundle install --path vendor/bundle
RUN sed -i -e "s/localhost:27017/epdb:27017/" config/mongoid.yml


# Add hub public key
#
COPY ./known_hosts /root/.ssh/


# Create startup script and make it executable
#
RUN mkdir -p /etc/service/app
RUN ( \
      echo "#!/bin/bash"; \
      echo "#"; \
      echo "# Exit on errors or unitialized variables"; \
      echo "#"; \
      echo "set -e -o nounset"; \
      echo ""; \
      echo "# Wait until SSH keys are ready"; \
      echo "#"; \
      echo "while [ -f /app/wait ]"; \
      echo "do"; \
      echo "  echo 'Waiting for key exchange'"; \
      echo "  sleep 5"; \
      echo "done"; \
      echo ""; \
      echo "# Start tunnel"; \
      echo "#"; \
      echo "export AUTOSSH_PIDFILE=/app/tmp/pids/autossh.pid"; \
      echo "export REMOTE_PORT=\`expr 40000 + \${gID}\`"; \
      echo ""; \
      echo "/usr/bin/autossh -M0 -p2774 -N -R \${REMOTE_PORT}:localhost:3001 autossh@\${URL_HUB} -o ServerAliveInterval=15 -o ServerAliveCountMax=3 -o Protocol=2 -o ExitOnForwardFailure=yes &"; \
      echo "sleep 5"; \
      echo ""; \
      echo "# Start Endpoint"; \
      echo "#"; \
      echo "cd /app/"; \
      echo "exec /sbin/setuser app '/app/runme.sh'"; \
    )  \
    >> /etc/service/app/run
RUN chmod +x /etc/service/app/run


# Create key exchange script, uses a wait file (/app/wait)
#
RUN ( \
      echo "#!/bin/bash"; \
      echo "#"; \
      echo "# Exit on errors or unitialized variables"; \
      echo "#"; \
      echo "set -e -o nounset"; \
      echo ""; \
      echo "# Create an SSH key and exchange it, if necessary"; \
      echo "#"; \
      echo "if [ ! -s /root/.ssh/id_rsa.pub ]"; \
      echo "then"; \
      echo "  ssh-keygen -t rsa -f /root/.ssh/id_rsa -q -N \"\""; \
      echo "fi"; \
      echo ""; \
      echo "# Echo the public key"; \
      echo "#"; \
      echo "cat /root/.ssh/id_rsa.pub"; \
      echo ""; \
      echo "# Wait 5 seconds and remove the hold on Endpoint startup"; \
      echo "#"; \
      echo "sleep 5"; \
      echo "rm /app/wait"; \
    )  \
    >> /app/key_exchange.sh
RUN chmod +x /app/key_exchange.sh
RUN touch /app/wait


# Run initialization command
#
CMD ["/sbin/my_init"]
