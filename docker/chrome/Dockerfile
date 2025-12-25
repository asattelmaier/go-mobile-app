FROM ubuntu:22.04

ARG CHROME_VERSION=131.0.6778.204

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    ca-certificates \
    gnupg \
    libgtk-3-0 \
    libnss3 \
    libxss1 \
    libasound2 \
    libgbm1 \
    fonts-liberation \
    libappindicator3-1 \
    && rm -rf /var/lib/apt/lists/*

# Install Chrome for Testing
RUN curl -fLO "https://storage.googleapis.com/chrome-for-testing-public/${CHROME_VERSION}/linux64/chrome-linux64.zip" \
    && unzip chrome-linux64.zip \
    && mv chrome-linux64 /usr/local/chrome-linux64 \
    && ln -s /usr/local/chrome-linux64/chrome /usr/bin/google-chrome \
    && rm chrome-linux64.zip

# Install Chromedriver
RUN curl -fLO "https://storage.googleapis.com/chrome-for-testing-public/${CHROME_VERSION}/linux64/chromedriver-linux64.zip" \
    && unzip chromedriver-linux64.zip \
    && mv chromedriver-linux64/chromedriver /usr/local/bin/chromedriver \
    && chmod +x /usr/local/bin/chromedriver \
    && rm chromedriver-linux64.zip

# Expose Chromedriver port
EXPOSE 4444

# Create a start script to launch Chromedriver with correct keys
RUN echo '#!/bin/bash\nchromedriver --port=4444 --whitelisted-ips=""' > /start.sh && \
    chmod +x /start.sh

CMD ["/start.sh"]
