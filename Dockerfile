# Use Maven base image with JDK 11
FROM maven:3.8.2-jdk-11 as builder

# Set JMeter version and home directory variables
ARG JMETER_VERSION=5.6.2
ENV JMETER_VERSION=${JMETER_VERSION}
ENV JMETER_HOME=/opt/jmeter

# Install utilities, download and extract JMeter, move to JMETER_HOME
RUN apt-get update \
    && apt-get install -y wget unzip \
    && wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz \
    && tar -xzf apache-jmeter-${JMETER_VERSION}.tgz -C /opt \
    && mv /opt/apache-jmeter-${JMETER_VERSION} ${JMETER_HOME} \
    && rm apache-jmeter-${JMETER_VERSION}.tgz \
    && apt-get clean

# Create lib and lib/ext directories to hold jars and plugins
RUN mkdir -p ${JMETER_HOME}/lib/ext

# Copy plugin jars to proper locations inside container
COPY dependency/cmdrunner-2.0.jar ${JMETER_HOME}/lib/
COPY dependency/jmeter-plugins-manager-1.11.jar ${JMETER_HOME}/lib/ext/
COPY dependency/jmeter-plugins-casutg-2.9.jar ${JMETER_HOME}/lib/ext/


# Run the Plugin Manager installer to handle plugin dependencies
RUN java -cp ${JMETER_HOME}/lib/ext/jmeter-plugins-manager-1.11.jar org.jmeterplugins.repository.PluginManagerCMDInstaller

# Add JMeter bin folder to PATH
ENV PATH="${JMETER_HOME}/bin:${PATH}"

# Set working directory to JMeter home
WORKDIR ${JMETER_HOME}

# Run 'jmeter' executable by default
ENTRYPOINT ["jmeter"]
