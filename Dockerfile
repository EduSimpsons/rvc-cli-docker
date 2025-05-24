FROM python:3.9-slim
WORKDIR /usr/local/rvc-cli

# System-Pakete
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ffmpeg libsndfile1 build-essential wget && \
    wget -q https://dl.min.io/client/mc/release/linux-amd64/mc && \
    install -m 755 mc /usr/local/bin/mc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Projektdateien (Code, requirements.txt, entrypoint.sh, …)
COPY . .

# Skript ausführbar machen, Python-Abhängigkeiten und Modell-Prereqs installieren
RUN chmod +x entrypoint.sh && \
    pip install --default-timeout=100 --no-cache-dir -r requirements.txt && \
    python3 rvc_cli.py prerequisites

ENTRYPOINT ["./entrypoint.sh"]