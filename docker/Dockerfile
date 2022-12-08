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
  && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
WORKDIR /stable-diffusion-webui

# this is optional, but avoids downloading 1.5GiB files on every "docker run"
RUN git clone https://huggingface.co/openai/clip-vit-large-patch14 openai/clip-vit-large-patch14 && \
  mv openai/clip-vit-large-patch14/pytorch_model.bin openai/clip-vit-large-patch14/pytorch_model.bin.bak && \
  aria2c -d openai/clip-vit-large-patch14 https://huggingface.co/openai/clip-vit-large-patch14/resolve/main/pytorch_model.bin

RUN python -u launch.py --skip-torch-cuda-test --exit

# TODO: "pip install xformers" will be available, see https://github.com/facebookresearch/xformers/issues/533
RUN pip install https://github.com/AbdBarho/stable-diffusion-webui-docker/releases/download/3.1.0/xformers-0.0.15.dev0+4e3631d.d20221125-cp310-cp310-linux_x86_64.whl

CMD [ "python", "-u", "launch.py", "--xformers", "--no-half-vae", "--listen" ]
