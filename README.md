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
git clone https://github.com/susumuota/stable-diffusion-minimal-docker.git
cd stable-diffusion-minimal-docker/docker
mkdir -p models/Stable-diffusion
aria2c -d models/Stable-diffusion https://huggingface.co/stabilityai/stable-diffusion-2-1/resolve/main/v2-1_768-ema-pruned.ckpt
aria2c -d models/Stable-diffusion -o v2-1_768-ema-pruned.yaml https://raw.githubusercontent.com/Stability-AI/stablediffusion/main/configs/stable-diffusion/v2-inference-v.yaml
ls -l models/Stable-diffusion
sha256sum models/Stable-diffusion/v2-1_768-ema-pruned.ckpt
# should be same SHA256 as https://huggingface.co/stabilityai/stable-diffusion-2-1/blob/main/v2-1_768-ema-pruned.ckpt
cd ..
```

TODO: create a Dockerfile for model downloads


## Build image

- https://docs.docker.com/compose/install/linux/#install-using-the-repository

```sh
sudo apt update
sudo apt install -y docker-compose-plugin
cd docker  # or docker-cpu
docker compose build
```

## Start webui

```sh
docker compose up -d
docker compose logs --no-log-prefix -f
```

Access http://localhost:7860/

## Stop webui

```sh
docker compose down
```

## Copy outputs

GCS might be convenient to transfer output data to local computer.

- https://cloud.google.com/storage/docs/gsutil/commands/mb
- https://cloud.google.com/storage/docs/gsutil/commands/cp
- https://cloud.google.com/storage/docs/gsutil/commands/rb

```sh
tar cfz outputs.tgz outputs
gsutil mb -l us-central1 gs://sd-outputs-2  # create a bucket
# gcloud storage buckets describe gs://sd-outputs-2  # confirm settings
gsutil cp outputs.tgz gs://sd-outputs-2/
# gsutil rb gs://sd-outputs-2/  # remove the bucket
```

Or you can use `scp`. Open terminal on local machine,

- https://cloud.google.com/sdk/gcloud/reference/compute/scp

```sh
gcloud compute scp --zone "us-central1-f" --project "(project id)" instance-1:~/stable-diffusion-minimal-docker/docker/outputs.tgz .
```

## Setup on GCE

### Create a project

Follow this instruction.

- https://cloud.google.com/resource-manager/docs/creating-managing-projects#creating_a_project

## Enable billing

Follow this instruction.

- https://cloud.google.com/billing/docs/how-to/modify-project#how-to-enable-billing

### Create a instance

- https://cloud.google.com/compute/docs/instances/create-start-instance

- Open https://console.cloud.google.com/compute/instances
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

Monthly estimate should be like this.

> Monthly estimate
>
> $126.66
>
> That's about $0.17 hourly

Instances table will show.

- Press triangle on the right of `SSH`
  - `View gcloud command`
  - `COPY TO CLIPBOARD`

Open a terminal on the local machine and paste the clipboard and add `-- -L 7860:localhost:7860` for port forwarding.

```sh
gcloud compute ssh --zone "us-central1-f" "instance-1"  --project "(project id)" -- -L 7860:localhost:7860
```

You will be asked to install Nvidia driver. Press `y`.

```sh
Would you like to install the Nvidia driver? [y/n]
```

Confirm driver versions.

```sh
nvidia-smi
```

Run `screen`. If you got disconnected during sessions, ssh again and `screen -r` to resume sessions.

```sh
screen
```

Then follow the instructions on `Download model files` section above.

### Delete the instance

**DON'T FORGET TO DELETE INSTANCES**

- https://console.cloud.google.com/compute/instances
- https://cloud.google.com/compute/docs/instances/stop-start-instance#billing

- Check `instance-1` on the VM list.
- Press `DELETE` button.

If you `DELETE` the VM instance, you will not be charged anything (as far as I know).

However, if you `STOP` the VM instance, you will be charged for resources (e.g. persistent disk) until you `DELETE` it. You should `DELETE` if you do not use it for a long time (though you must setup the environment again).

### Delete the project

- https://cloud.google.com/resource-manager/docs/creating-managing-projects#shutting_down_projects



## License

MIT License, See LICENSE file.

## Author

Susumu OTA
