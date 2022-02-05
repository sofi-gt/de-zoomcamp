# Use terraform to create a VM instance in GCloud

I will be adapting the code from the course to create a VM instance in Google Cloud.

## Create a folder to store the terraform files
```bash
mkdir terraform_vm
cd terraform_vm
```

Create `main.tf` file
```bash
touch main.tf
```

Create `variables.tf` file

```bash
touch variables.tf
```

## Modify main file

Will keep the same terraform configuration string

```
terraform {
  required_version = ">= 1.0"
  backend "local" {}  # Can change from "local" to "gcs" (for google) or "s3" (for aws), if you would like to preserve your tf-state online
  required_providers {
    google = {
      source  = "hashicorp/google"
    }
  }
}
```

Will keep the same provider

```
provider "google" {
  project = var.project
  region = var.region
  // credentials = file(var.credentials)  # Use this if you do not want to set env-var GOOGLE_APPLICATION_CREDENTIALS
}
```

Search Google VM instance resource
https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance

```
resource "google_compute_instance" "default" {
  name         = "${local.vm}_{var.project}"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}

```




```
gcloud compute instances create de-zoomcamp --project=phrasal-pad-338818 --zone=us-central1-c --machine-type=e2-standard-4 --network-interface=network-tier=PREMIUM,subnet=default --maintenance-policy=MIGRATE --service-account=795939079675-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --create-disk=auto-delete=yes,boot=yes,device-name=de-zoomcamp,image=projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20220118,mode=rw,size=50,type=projects/phrasal-pad-338818/zones/us-central1-c/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any
```