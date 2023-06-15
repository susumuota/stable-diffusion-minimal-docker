FROM ubuntu:22.04
# FROM python:3.10-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
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

RUN TORCH_INDEX_URL="https://download.pytorch.org/whl/cpu" ./webui.sh -f --skip-torch-cuda-test --exit

RUN sed -i -e 's/    return "cpu"/    torch.set_num_threads(8)\n    return "cpu"/' modules/devices.py
COPY config.json .

CMD [ "./webui.sh", "-f", "--skip-torch-cuda-test", "--use-cpu=all", "--no-half", "--no-half-vae", "--listen" ]
