FROM alpine:3

RUN apk add --no-cache aria2

WORKDIR /download

CMD mkdir -p models/Stable-diffusion && \
  aria2c -d models/Stable-diffusion -o v2-1_768-ema-pruned.ckpt https://huggingface.co/stabilityai/stable-diffusion-2-1/resolve/main/v2-1_768-ema-pruned.ckpt && \
  aria2c -d models/Stable-diffusion -o v2-1_768-ema-pruned.yaml https://raw.githubusercontent.com/Stability-AI/stablediffusion/main/configs/stable-diffusion/v2-inference-v.yaml && \
  sha256sum models/Stable-diffusion/v2-1_768-ema-pruned.ckpt
