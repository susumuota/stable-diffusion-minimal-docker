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
  aria2c -x5 -d openai/clip-vit-large-patch14 https://huggingface.co/openai/clip-vit-large-patch14/resolve/main/pytorch_model.bin

# replace "cu113" to "cpu"
RUN sed -i -e "/pip install torch/ s/cu[0-9]\{3,\}/cpu/g" launch.py
RUN python -u launch.py --skip-torch-cuda-test --exit

# this may improve the perfomance
RUN sed -i -e "s/    return cpu/    torch.set_num_threads(8)\n    return cpu/" modules/devices.py

CMD [ "python", "-u", "launch.py", "--skip-torch-cuda-test", "--use-cpu=all", "--no-half", "--no-half-vae", "--listen" ]
