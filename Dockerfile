FROM microsoft/azure-cli
COPY . .
ENTRYPOINT ["/bin/bash"] 