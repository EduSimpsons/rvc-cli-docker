FROM python:3.9-slim
WORKDIR /usr/local/rvc-cli

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ffmpeg \
    libsndfile1 \
    build-essential \
    wget && \
    wget https://dl.min.io/client/mc/release/linux-amd64/mc && \
    chmod +x mc && \
    mv mc /usr/local/bin/

RUN apt-get clean; rm -rf /var/lib/apt/lists/*

# Install the application dependencies
COPY . ./
RUN pip install --default-timeout=100 --no-cache-dir -r requirements.txt

RUN python3 rvc_cli.py prerequisites

ENTRYPOINT [ "python3", "rvc_cli.py", "infer" ]