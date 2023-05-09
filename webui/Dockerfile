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

RUN python -u launch.py --skip-torch-cuda-test --xformers --exit

# this will fix the error:
#   `Could not load library libcudnn_cnn_infer.so.8. Error: libnvrtc.so: cannot open shared object file: No such file or directory`
#
# but I guess this error will be fixed by next PyTorch release
# https://discuss.pytorch.org/t/could-not-load-library-libcudnn-cnn-infer-so-8/175139/5
RUN (cd /usr/local/lib/python3.10/dist-packages/torch/lib && ln -s libnvrtc-672ee683.so.11.2 libnvrtc.so)

CMD [ "python", "-u", "launch.py", "--xformers", "--no-half-vae", "--listen" ]
