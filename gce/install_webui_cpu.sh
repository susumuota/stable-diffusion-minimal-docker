#!/bin/bash

sudo apt-get update && sudo apt-get install -y --no-install-recommends \
  aria2 \
  emacs \
  git \
  libgl1 \
  libglib2.0-0 \
  python-is-python3 \
  python3 \
  python3-pip \
  screen \
  && rm -rf /var/lib/apt/lists/*


git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
cd stable-diffusion-webui

sed -i -e "/pip install torch/ s/cu[0-9]\{3,\}/cpu/g" launch.py
sed -i -e 's/    return "cpu"/    torch.set_num_threads(4)\n    return "cpu"/' modules/devices.py
python -u launch.py --skip-torch-cuda-test --exit

echo "run 'python -u launch.py --skip-torch-cuda-test --use-cpu=all --no-half --no-half-vae'"
