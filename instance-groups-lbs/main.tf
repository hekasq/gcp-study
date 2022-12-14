#################
#  Load Balancer
#################

resource "google_compute_region_backend_service" "backend" {
  provider              = google-beta
  name                  = "backend-lb"
  region                = "us-central1"
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_region_health_check.hc.id]
  #pointing load balancer at the MiG
  backend {
    group = google_compute_instance_group_manager.mig.instance_group
  }
}
/*
resource "google_compute_forwarding_rule" "fwd_rule" {

  name = "fwd-rule"
  provider = google-beta
  region                = "us-central1"
  target = ""
}*/

resource "google_compute_region_health_check" "hc" {
  provider           = google-beta
  name               = "check-website-backend"
  check_interval_sec = 1
  timeout_sec        = 1
  region             = "us-central1"

  tcp_health_check {
    port = "80"
  }
}

#################
#  MIG
#################
resource "google_compute_instance_group_manager" "mig" {
  base_instance_name = "mig-instance"
  name               = "mig"
  version {
    instance_template = google_compute_instance_template.template.id
  }
  # Use target_size unless attached to auto-scaler
  # target_size = 3
  zone = "us-central1-a"
  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.id
    initial_delay_sec =30
  }
}


#################
#  AUTOSCALER
#################
resource "google_compute_autoscaler" "default" {
  zone   = "us-central1-a"
  name   = "mig-autoscaler"
  target = google_compute_instance_group_manager.mig.id
  autoscaling_policy {
    max_replicas    = 6
    min_replicas    = 4
    cooldown_period = 60
  }
}


#################
#  Standard healthcheck
#################
resource "google_compute_health_check" "autohealing" {
  name                = "autohealing-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # 50 seconds

  http_health_check {
    port = 80
  }
}


#################
#  INSTANCE TEMPLATE MANDATORY FOR MIG
#################
resource "google_compute_instance_template" "template" {

  metadata_startup_script = file("${path.module}/scripts/startup.sh")
  machine_type            = "e2-medium"
  disk {
    source_image = "debian-cloud/debian-11"
  }
  network_interface {
    network = "default"
  }
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


