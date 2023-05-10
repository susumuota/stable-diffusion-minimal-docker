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

# replace "cu118" to "cpu"
RUN sed -i -e "/pip install torch/ s/cu[0-9]\{3,\}/cpu/g" launch.py
RUN sed -i -e 's/    return "cpu"/    torch.set_num_threads(4)\n    return "cpu"/' launch.py
RUN python -u launch.py --skip-torch-cuda-test --exit

CMD [ "python", "-u", "launch.py", "--skip-torch-cuda-test", "--use-cpu=all", "--no-half", "--no-half-vae", "--listen" ]
