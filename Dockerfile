FROM vignesh123456/corretto11:1.0

# Set the WILDFLY_VERSION env variables
ENV WILDFLY_VERSION 20.0.1.Final
ENV WILDFLY_SHA1 95366b4a0c8f2e6e74e3e4000a98371046c83eeb
ENV JBOSS_HOME /opt/connectleader/wildfly

USER root
# Add the WildFly distribution to /opt, and make wildfly the owner of the extracted tar content
# Make sure the distribution is available from a well-known place
RUN cd $HOME \
    && mkdir /opt/connectleader/ \
	&& mv /etc/localtime /etc/localtime_orig \
    && ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime \
    && curl -O https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz \
    && sha1sum wildfly-$WILDFLY_VERSION.tar.gz | grep $WILDFLY_SHA1 \
    && yum install -y tar* \
    && tar xf wildfly-$WILDFLY_VERSION.tar.gz \
    && mv $HOME/wildfly-$WILDFLY_VERSION $JBOSS_HOME \
    && rm wildfly-$WILDFLY_VERSION.tar.gz \
    && sed -i 's/127.0.0.1}"/0.0.0.0}"/g' /opt/connectleader/wildfly/standalone/configuration/standalone.xml \
    && sed -i 's/8443/443/g' /opt/connectleader/wildfly/standalone/configuration/standalone.xml \
    && sed -i 's/8080/80/g' /opt/connectleader/wildfly/standalone/configuration/standalone.xml \
	&& sed -i 's/9990/9995/g' /opt/connectleader/wildfly/standalone/configuration/standalone.xml \
    && chown root:root /opt/* \
	&& mkdir -p /etc/wildfly \
    && cp /opt/connectleader/wildfly/docs/contrib/scripts/systemd/wildfly.conf /etc/wildfly/ \
    && cp /opt/connectleader/wildfly/docs/contrib/scripts/systemd/launch.sh /opt/connectleader/wildfly/bin/ \
    && sh -c 'chmod +x /opt/connectleader/wildfly/bin/*.sh' \
    && cp /opt/connectleader/wildfly/docs/contrib/scripts/systemd/wildfly.service /etc/systemd/system/ \
    && sed -i 's/=wildfly/=root/g' /etc/systemd/system/wildfly.service \
	&& sed -i 's/-Xms64M/-Xms512M/g' /opt/connectleader/wildfly/bin/standalone.conf \
	&& sed -i 's/-Xms256M/-Xms512M/g' /opt/connectleader/wildfly/bin/standalone.conf \
	&& sed -i 's/=64M/=512M/g' /opt/connectleader/wildfly/bin/standalone.conf \
	&& sed -i 's/=256m/=2G/g' /opt/connectleader/wildfly/bin/standalone.conf \
    && chmod -R g+rw ${JBOSS_HOME} \
	&& sleep 15 \
	&& mkdir sox \
    && cd sox \
    && wget http://sourceforge.net/projects/sox/files/sox/14.4.2/sox-14.4.2.tar.gz \
    && tar xvfz sox-14.4.2.tar.gz \
    && yum install gcc -y \
    && cd sox-14.4.2 \
    && ./configure \
	&& yum install make -y \
    && make -s \
    && make install \
    && export PATH=$PATH:/usr/local/bin \
    && ldconfig
	


# Ensure signals are forwarded to the JVM process correctly for graceful shutdown
ENV LAUNCH_JBOSS_IN_BACKGROUND true

#RUN yum install epel-release -y
#RUN yum install jq -y

ARG APP_FILE=target/CounterWebApp.war
# Add your application to the deployment folder
ADD ${APP_FILE} /opt/connectleader/wildfly/standalone/deployments/${APP_FILE}

USER root

# Expose the ports we're interested in
EXPOSE 80 9995
RUN /opt/connectleader/wildfly/bin/add-user.sh admin Admin#123 --silent


# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface
CMD ["/opt/connectleader/wildfly/bin/standalone.sh", "-b", "0.0.0.0","-bmanagement", "0.0.0.0"]
