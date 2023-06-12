FROM ubuntu:22.04
# FROM python:3.10-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
  aria2 \
  git \
  libgl1 \
  libglib2.0-0 \
  python-is-python3 \
  python3 \
  python3-pip \
  python3-venv \
  && rm -rf /var/lib/apt/lists/*


RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
WORKDIR /stable-diffusion-webui

RUN ./webui.sh -f --xformers --exit

COPY config.json .

CMD [ "./webui.sh", "-f", "--xformers", "--no-half-vae", "--listen" ]
