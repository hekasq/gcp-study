provider "google" {
  project = "gcp-arch-362703"
  region  = "us-central1"
}


#################
# VM FROM TEMPLATE
#################
resource "google_compute_instance_from_template" "templated" {
  count = 3
  source_instance_template = google_compute_instance_template.template.id
  name                     = "vm-from-tpl-${count.index}"
  zone                    = "us-central1-a"
}

resource "google_compute_instance_template" "template" {

  metadata_startup_script = file("${path.module}/scripts/startup.sh")
  machine_type = "e2-medium"
  disk {
    source_image = "debian-cloud/debian-11"
  }
  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static2.address
    }
  }
}

resource "google_compute_address" "static2" {
  name = "ipv4-address-2"
}

#################
# BASIC SINGLE VM
#################

#basic VM
resource "google_compute_instance" "default" {
  name                    = "vm1-gce"
  machine_type            = "e2-medium"
  zone                    = "us-central1-a"
  # ensures startup script is run when vm is created - bootstrapped
  metadata_startup_script = file("${path.module}/scripts/startup.sh")
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static.address
    }
  }
}


#Provides static external ip address
resource "google_compute_address" "static" {
  name = "ipv4-address"
}




#################
# Allows HTTP Traffic
#################
resource "google_compute_firewall" "allow_http" {
  name          = "allow-http-rule"
  source_ranges = ["0.0.0.0/0"]
  network       = "default"
  allow {
    ports    = ["80"]
    protocol = "tcp"
  }
  priority = 1000

}
