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

# this may improve the perfomance
RUN sed -i -e "s/    return cpu/    torch.set_num_threads(8)\n    return cpu/" modules/devices.py

# this is optional but it avoids downloading a 3.94GB file on everytime "docker run"
# TODO: refine.
#   according to this page, https://huggingface.co/docs/huggingface_hub/how-to-downstream
#   I guess there is a code like this somewhere.
#     hf_hub_download(repo_id="laion/CLIP-ViT-H-14-laion2B-s32B-b79K", filename="open_clip_pytorch_model.bin", revision="58a1e03a7acfacbe6b95ebc24ae0394eda6a14fc")
RUN mkdir -p /root/.cache/huggingface/hub/models--laion--CLIP-ViT-H-14-laion2B-s32B-b79K && \
  cd /root/.cache/huggingface/hub/models--laion--CLIP-ViT-H-14-laion2B-s32B-b79K && \
  mkdir -p refs blobs snapshots/58a1e03a7acfacbe6b95ebc24ae0394eda6a14fc && \
  echo -n 58a1e03a7acfacbe6b95ebc24ae0394eda6a14fc > refs/main && \
  aria2c -d blobs -o 9a78ef8e8c73fd0df621682e7a8e8eb36c6916cb3c16b291a082ecd52ab79cc4 \
    https://huggingface.co/laion/CLIP-ViT-H-14-laion2B-s32B-b79K/resolve/main/open_clip_pytorch_model.bin && \
  cd snapshots/58a1e03a7acfacbe6b95ebc24ae0394eda6a14fc && \
  ln -s ../../blobs/9a78ef8e8c73fd0df621682e7a8e8eb36c6916cb3c16b291a082ecd52ab79cc4 open_clip_pytorch_model.bin

CMD [ "python", "-u", "launch.py", "--skip-torch-cuda-test", "--use-cpu=all", "--no-half", "--no-half-vae", "--listen" ]
