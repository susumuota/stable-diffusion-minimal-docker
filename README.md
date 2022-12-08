# Stable Diffusion Minimal Docker

Minimal docker files to download [Stable Diffusion v2-1 model](https://huggingface.co/stabilityai/stable-diffusion-2-1) and to run [AUTOMATIC1111's stable-diffusion-webui](https://github.com/AUTOMATIC1111/stable-diffusion-webui) on Google Compute Engine (GCE).

I have tested it on,

- Google Compute Engine (GCE) with Deep Learning VM image with NVIDIA T4
- macOS 12.6.1 without GPUs

If you want to setup on GCE, see `Setup on GCE` section first.

## Install Docker and Docker Compose

- https://docs.docker.com/engine/install/

If you are using GCE with Deep Learning VM image, you only need to install `docker-compose-plugin`.

```sh
sudo apt update
sudo apt install -y docker-compose-plugin
```

## Download model files

Here, we are going to download Stable Diffusion v2-1 model (`v2-1_768-ema-pruned.ckpt`).

- https://huggingface.co/stabilityai/stable-diffusion-2-1
- https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki/Features#stable-diffusion-20

```sh
git clone https://github.com/susumuota/stable-diffusion-minimal-docker
cd stable-diffusion-minimal-docker/download-sd-v2-1
docker compose build
docker compose up
# confirm SHA256 on the log
ls -l models/Stable-diffusion
# total 5092652
# -rw-r--r-- 1 root root 5214865159 Dec  8 06:38 v2-1_768-ema-pruned.ckpt
# -rw-r--r-- 1 root root       1815 Dec  8 06:38 v2-1_768-ema-pruned.yaml
docker compose down
cd ..
```

To confirm SHA256, see this page.

- https://huggingface.co/stabilityai/stable-diffusion-2-1/blob/main/v2-1_768-ema-pruned.ckpt

## Build image

```sh
cd webui  # or webui-cpu
docker compose build
```

## Start webui

Move model files from download directory.

```sh
sudo mv ../download-sd-v2-1/models/Stable-diffusion models
```

TODO: fix sudo above.

Start webui.

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
gsutil mb -l us-central1 gs://sd-outputs-2           # create a bucket
gsutil cp outputs.tgz gs://sd-outputs-2/             # copy to the bucket
# gsutil rb gs://sd-outputs-2/                       # remove the bucket
```

Or you can use `scp`. Open terminal on local machine,

- https://cloud.google.com/sdk/gcloud/reference/compute/scp

```sh
gcloud compute scp --zone "us-central1-f" --project "(project id)" instance-1:~/stable-diffusion-minimal-docker/docker/outputs.tgz .
```

## Setup on GCE

### Install gcloud CLI

- https://cloud.google.com/sdk/docs/install

### Create a project

- https://cloud.google.com/resource-manager/docs/creating-managing-projects#creating_a_project

### Enable billing

- https://cloud.google.com/billing/docs/how-to/modify-project#how-to-enable-billing

### Increase GPU quotas

- https://cloud.google.com/compute/quotas#requesting_additional_quota

### Create a instance

- https://cloud.google.com/compute/docs/instances/create-start-instance

![gce_create_instance](https://user-images.githubusercontent.com/1632335/206372246-37fe9289-bac5-4297-ba61-ab9f34b2d257.png)

- Open https://console.cloud.google.com/compute/instances
- Press `CREATE INSTANCE`
  - Region - `us-central1 (Iowa)`
  - Zone - `us-central1-f`  # whatever you want
  - Machine configuration
    - Machine family - `GPU`
    - GPU type - `NVIDIA T4`  # or higher
    - Machine type - `n1-highmem-4 (4 vCPU, 26GB memory)`  # or `n1-standard-4`
  - Boot disk - `CHANGE`
    - Operating system - `Deep Learning on Linux`
    - Version - `Debian 10 based Deep Learning VM with M100`  # description is `Base CUDA 11.0, Deep Learning VM image with CUDA 11.0 preinstalled.`
    - Size (GB) - `100`  # `50` might be too small
    - Press `SELECT`
  - Identity and API access  # if you use GCS buckets to save outputs
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

### SSH to VM

![ssh_options](https://user-images.githubusercontent.com/1632335/206373060-e56f2f8f-0309-4b45-81ee-46ce8af42907.png)

- Press triangle on the right of `SSH`
  - `View gcloud command`
  - `COPY TO CLIPBOARD`

Open a terminal on the local machine and paste the clipboard and add `-- -L 7860:localhost:7860` for port forwarding.

```sh
gcloud compute ssh --zone "us-central1-f" "instance-1"  --project "(project id)" -- -L 7860:localhost:7860
```

You will be asked to install Nvidia driver. Input `y`.

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

If you want to confirm that you will not be charged anymore, delete the project.

- https://cloud.google.com/resource-manager/docs/creating-managing-projects#shutting_down_projects

## Links

- https://github.com/AUTOMATIC1111/stable-diffusion-webui
- https://github.com/AbdBarho/stable-diffusion-webui-docker

## License

MIT License, See LICENSE file.

## Author

Susumu OTA
