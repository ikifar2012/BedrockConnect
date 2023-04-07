FROM alpine:latest

# Install necessary packages
RUN apk add --no-cache dnsmasq

# Copy custom configuration
COPY run.sh run.sh
RUN chmod +x run.sh

# Expose DNS port
EXPOSE 53/udp
EXPOSE 53/tcp

# Start DNS service
CMD ["sh", "run.sh"]