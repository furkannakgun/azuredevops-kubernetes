FROM ubuntu:20.04

# Update and install packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        git \
        jq \
        iputils-ping

# Install the Azure DevOps agent
ARG AZP_AGENT_VERSION=3.220.0
RUN curl -LsS https://vstsagentpackage.azureedge.net/agent/${AZP_AGENT_VERSION}/vsts-agent-linux-x64-${AZP_AGENT_VERSION}.tar.gz -o /tmp/vsts-agent.tar.gz && \
    mkdir -p /azp && \
    tar zxvf /tmp/vsts-agent.tar.gz -C /azp && \
    rm -f /tmp/vsts-agent.tar.gz

# Configure the agent startup script
COPY ./start.sh /azp/
RUN chmod +x /azp/start.sh

# Set the working directory
WORKDIR /azp

# Start the agent
CMD ["./start.sh"]
