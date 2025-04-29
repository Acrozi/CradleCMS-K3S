resource "proxmox_vm_qemu" "cloudinit-k3s-master" {
  count       = 2
  name        = "k3s-master-${count.index + 1}"
  desc        = "Cloudinit Debian - K3s Master ${count.index + 1}"
  target_node = var.proxmox_host
  clone       = var.template_name
  vmid        = 100 + count.index
  onboot      = true
  agent       = 1
  os_type     = "cloud-init"
  memory      = 4096
  sockets     = 1
  cores       = 2
  vcpus       = 0
  cpu_type    = "host"
  numa        = false
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"

  disks {
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = 20
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    id = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=192.168.68.15${count.index + 1}/24,gw=192.168.68.1"
  ciuser    = var.ciuser
  sshkeys   = local.ssh_key

  serial {
    id   = 0
    type = "socket"
  }
}

resource "proxmox_vm_qemu" "cloudinit-k3s-worker" {
  count       = 3
  name        = "k3s-worker-${count.index + 1}"
  desc        = "Cloudinit Debian - K3s Worker ${count.index + 1}"
  target_node = var.proxmox_host
  clone       = var.template_name
  vmid        = 200 + count.index
  onboot      = true
  agent       = 1
  os_type     = "cloud-init"
  memory      = 4096
  sockets     = 1
  cores       = 2
  vcpus       = 0
  cpu_type    = "host"
  numa        = false
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"

  disks {
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = 15
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    id = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=192.168.68.16${count.index + 1}/24,gw=192.168.68.1"
  ciuser    = var.ciuser
  sshkeys   = local.ssh_key

  serial {
    id   = 0
    type = "socket"
  }
}

resource "proxmox_vm_qemu" "cloudinit-k3s-ansible" {
  count       = 1
  name        = "k3s-ansible-${count.index + 1}"
  desc        = "Cloudinit Debian - K3s Ansible"
  target_node = var.proxmox_host
  clone       = var.template_name
  vmid        = 300 + count.index
  onboot      = true
  agent       = 1
  os_type     = "cloud-init"
  memory      = 4096
  sockets     = 1
  cores       = 2
  vcpus       = 0
  cpu_type    = "host"
  numa        = false
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"

  disks {
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = 20
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    id = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=192.168.68.181/24,gw=192.168.68.1"
  ciuser    = var.ciuser
  sshkeys   = local.ssh_key

  serial {
    id   = 0
    type = "socket"
  }
}