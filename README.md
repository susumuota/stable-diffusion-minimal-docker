# Stable Diffusion Minimal Docker

This docker runs [AUTOMATIC1111's stable-diffusion-webui](https://github.com/AUTOMATIC1111/stable-diffusion-webui).

I have tested it on

- Google Compute Engine (GCE) with Deep Learning VM image with NVIDIA T4
- macOS 12.6.1 without GPUs

## Download model files

- https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki/Features#stable-diffusion-20

```sh
sudo apt update
sudo apt install -y aria2
cd docker
mkdir -p models/Stable-diffusion
aria2c -x5 -d models/Stable-diffusion https://huggingface.co/stabilityai/stable-diffusion-2-1/resolve/main/v2-1_768-ema-pruned.ckpt
aria2c -d models/Stable-diffusion -o v2-1_768-ema-pruned.yaml https://raw.githubusercontent.com/Stability-AI/stablediffusion/main/configs/stable-diffusion/v2-inference-v.yaml
ls -l models/Stable-diffusion
cd ..
```

## Build image

```sh
cd docker
docker-compose build
```

## Start webui

```sh
docker-compose up -d
docker-compose logs --no-log-prefix -f
```

Access http://localhost:7860/

## Stop webui

```sh
docker-compose down
```

## Copy outputs

TODO


## Setup on GCE

- https://console.cloud.google.com/compute/instances

- Press `CREATE INSTANCE`
  - Region - `us-central1 (Iowa)`
  - Zone - `us-central1-f`
  - Machine configuration
    - Machine family - `GPU`
    - GPU type - `NVIDIA T4`  # or higher
    - Machine type - `n1-highmem-4 (4 vCPU, 26GB memory)`  # or `n1-standard-4`
  - Boot disk - `CHANGE`
    - Operating system - `Deep Learning on Linux`
    - Version - `Debian 10 based Deep Learning VM with M100`
    - Size (GB) - `100`  # or `50`
    - Press `SELECT`
  - Identity and API access  # if you use GCS
    - Access scopes - `Set access for each API`
      - Storage - `Full`
  - Advanced options
    - Management
      - Availability policies
        - VM Provisioning model - `Spot`  # if you prefer low-cost instead of stability
- Press `CREATE`


> Monthly estimate
>
> $126.66
>
> That's about $0.17 hourly

## License

MIT License, See LICENSE file.

## Author

Susumu OTA
