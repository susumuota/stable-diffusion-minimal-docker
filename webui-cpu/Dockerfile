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

# replace "cu113" to "cpu"
RUN sed -i -e "/pip install torch/ s/cu[0-9]\{3,\}/cpu/g" launch.py
RUN python -u launch.py --skip-torch-cuda-test --exit

# for SD 1.4/1.5 models
# this is optional but it avoids downloading a 1.71GB file on everytime "docker run"
RUN git clone https://huggingface.co/openai/clip-vit-large-patch14 openai/clip-vit-large-patch14 && \
  mv openai/clip-vit-large-patch14/pytorch_model.bin openai/clip-vit-large-patch14/pytorch_model.bin.bak && \
  aria2c -d openai/clip-vit-large-patch14 https://huggingface.co/openai/clip-vit-large-patch14/resolve/main/pytorch_model.bin

# for SD 2.0/2.1 models
# this is optional but it avoids downloading a 3.94GB file on everytime "docker run"
RUN python -c "from huggingface_hub import hf_hub_download; hf_hub_download(repo_id='laion/CLIP-ViT-H-14-laion2B-s32B-b79K', filename='open_clip_pytorch_model.bin')"


CMD [ "python", "-u", "launch.py", "--skip-torch-cuda-test", "--use-cpu=all", "--no-half", "--no-half-vae", "--listen" ]
