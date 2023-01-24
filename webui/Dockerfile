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

# for SD 2.0/2.1 models
# this is optional but it avoids downloading a 3.94GB file on everytime "docker run"
# RUN pip install huggingface-hub && python -c "from huggingface_hub import hf_hub_download; hf_hub_download(repo_id='laion/CLIP-ViT-H-14-laion2B-s32B-b79K', filename='open_clip_pytorch_model.bin')"

# TODO: "pip install xformers" will be available, see https://github.com/facebookresearch/xformers/issues/533
RUN pip install xformers==0.0.16rc425

RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
WORKDIR /stable-diffusion-webui

RUN python -u launch.py --skip-torch-cuda-test --exit

CMD [ "python", "-u", "launch.py", "--xformers", "--no-half-vae", "--listen" ]
