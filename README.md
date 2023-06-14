# Stable Diffusion Minimal Docker

Minimal docker files to run [AUTOMATIC1111's stable-diffusion-webui](https://github.com/AUTOMATIC1111/stable-diffusion-webui) on [Google Compute Engine](https://cloud.google.com/compute).

I have tested it on,

- Google Compute Engine (GCE) with Ubuntu 22.04 VM image with NVIDIA L4 and T4
- macOS 13.2.1 without GPUs

If you use your local machine, you can skip to `Build image` section.

## Setup on GCE

### Install gcloud CLI

- https://cloud.google.com/sdk/docs/install

### Create a project

- https://cloud.google.com/resource-manager/docs/creating-managing-projects#creating_a_project

### Enable billing

- https://cloud.google.com/billing/docs/how-to/modify-project#how-to-enable-billing

### Increase GPU quotas

- https://cloud.google.com/compute/quotas#requesting_additional_quota

### Create an instance

- https://cloud.google.com/compute/docs/instances/create-start-instance

![gce_create_instance](https://user-images.githubusercontent.com/1632335/236401779-383db1ad-c44e-45a3-8416-f68297c189cf.png)

![gce_spot](https://user-images.githubusercontent.com/1632335/236403975-ff2690cf-4dc4-48fe-ae34-3cbd6471e380.png)

- Open https://console.cloud.google.com/compute/instances
- Press `CREATE INSTANCE`
  - Name - `instance-1`  # or any name you like
  - Region - `us-central1 (Iowa)`
  - Zone - `us-central1-a`  # NVIDIA L4 is available in `us-central1-a`
  - Machine configuration - `GPUs`
    - GPU type - `NVIDIA L4`  # or T4
    - Machine type - `g2-standard-4 (4 vCPU, 16GB memory)`  # or `n1-standard-4` for T4
  - Boot disk - `CHANGE`
    - Operating system - `Ubuntu`
    - Version - `Ubuntu 22.04 LTS`  # description is `x86/64, amd64 jammy image built on 2023-06-06, supports Shielded VM features`
    - Boot disk type - `SSD persistent disk`  # or `Balanced persistent disk` but SSD is not so expensive
    - Size (GB) - `50`  # `50` is enough for inference (not training)
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
> $163.30
>
> That's about $0.22 hourly

After you press `CREATE`, instances table will show.

![instances-table](https://user-images.githubusercontent.com/1632335/236405729-6f870c9c-9ace-47eb-a870-506313e19645.png)

### SSH to VM

![ssh_options](https://user-images.githubusercontent.com/1632335/236405480-f673a330-54c2-45b4-9e92-47f953486123.png)

- Press triangle on the right of `SSH`
  - `View gcloud command`
  - `COPY TO CLIPBOARD`

Open a terminal on the local machine and paste the clipboard and add `-- -L 7860:localhost:7860` for port forwarding.

```sh
gcloud compute ssh --zone "us-central1-a" "instance-1"  --project "(project id)" -- -L 7860:localhost:7860
```

### Install CUDA drivers

```sh
git clone https://github.com/susumuota/stable-diffusion-minimal-docker.git
```

```sh
bash ./stable-diffusion-minimal-docker/gce/create_dotfiles.sh
bash ./stable-diffusion-minimal-docker/gce/install_cuda_drivers.sh
sudo reboot  # and ssh again
```

## Option 1: Run webui without Docker

### Install webui

```sh
bash ./stable-diffusion-minimal-docker/gce/install_webui.sh
cd stable-diffusion-webui
```

### Download and copy model files

```sh
wget ...
cp *.ckpt models/Stable-diffusion
```

### Start webui

```sh
./webui.sh --xformers --no-half-vae
```

### Rsync outputs

On GCE instance,

```sh
bash ~/stable-diffusion-minimal-docker/gce/rsync_remote.sh
```

On local machine,

```sh
bash ~/stable-diffusion-minimal-docker/gce/rsync_local.sh
```

## Option 2: Run webui with Docker

### Install Docker and nvidia-container-toolkit

```sh
bash ./stable-diffusion-minimal-docker/gce/install_docker.sh
sudo reboot  # and ssh again
bash ./stable-diffusion-minimal-docker/gce/install_nvidia_container_toolkit.sh
```

### Build image

Make sure you cloned this repository.

```sh
git clone https://github.com/susumuota/stable-diffusion-minimal-docker.git
cd stable-diffusion-minimal-docker
```

Build docker image.

```sh
cd webui  # or webui-cpu
docker compose build
```

### Download and copy model files

```sh
wget ...
cp *.ckpt models/Stable-diffusion
```

### Start webui

```sh
docker compose up -d                    # start webui in background
docker compose logs --no-log-prefix -f  # show logs
```

Access http://localhost:7860/

### Stop webui

```sh
docker compose down
```

## Copy outputs

[Google Cloud Storage (GCS)](https://cloud.google.com/storage) might be convenient to transfer outputs data to your local computer.

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
gcloud compute scp --zone "us-central1-a" --project "(project id)" instance-1:~/stable-diffusion-minimal-docker/docker/outputs.tgz .
```

## Delete the instance

- https://console.cloud.google.com/compute/instances
- https://cloud.google.com/compute/docs/instances/stop-start-instance#billing

**DON'T FORGET TO DELETE INSTANCES**

- Select `instance-1` in the VM list.
- Press the `DELETE` button.

If you `DELETE` the VM instance, you will not be charged (as far as I know).

However, if you `STOP` the VM instance, you will be charged for resources (e.g. persistent disk) until you `DELETE` it. You should `DELETE` it if you are not going to use it for a long time (although you will have to setup the environment again).

## Delete the project

If you want to confirm that you will no longer be charged, delete the project.

- https://cloud.google.com/resource-manager/docs/creating-managing-projects#shutting_down_projects

## Links

- https://github.com/AUTOMATIC1111/stable-diffusion-webui
- https://github.com/AbdBarho/stable-diffusion-webui-docker

## License

MIT License, See LICENSE file.

## Author

Susumu OTA
