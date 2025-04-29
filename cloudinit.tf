resource "proxmox_vm_qemu" "cloudinit-k3s-master" {
  target_node = "s1"
  desc        = "Cloudinit debian  - K3s Master"
  count       = 2
  vmid        = 100 + count.index  # Generera unika VMID baserat på index
  onboot      = true
  clone       = "KubernetesNodeTemplate"
  agent       = 1

  os_type     = "cloud-init"
  cores       = 2
  sockets     = 1
  vcpus       = 0
  numa        = false
  cpu         = "host"
  memory      = 4096
  name        = "k3s-master-${count.index + 1}"

  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"

  # Setup the disk
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
          storage = "local-lvm"
          size    = 20
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=192.168.68.15${count.index + 1}/24,gw=192.168.68.1"
  ciuser    = "debian"
  serial {
    id   = 0
    type = "socket"
  }


  sshkeys = <<EOF
ssh-rsa key
EOF
}

resource "proxmox_vm_qemu" "cloudinit-k3s-worker" {
  target_node = "s1"
  desc        = "Cloudinit debian  - K3s Worker"
  count       = 3
  vmid        = 200 + count.index  # Generera unika VMID baserat på index
  onboot      = true
  clone       = "KubernetesNodeTemplate"
  agent       = 1

  os_type     = "cloud-init"
  cores       = 2
  sockets     = 1
  vcpus       = 0
  numa        = false
  cpu         = "host"
  memory      = 4096
  name        = "k3s-worker-${count.index + 1}"

  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"

  # Setup the disk
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
          storage = "local-lvm"
          size    = 15
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=192.168.68.16${count.index + 1}/24,gw=192.168.68.1"
  ciuser    = "debian"

  serial {
    id   = 0
    type = "socket"
  }

  sshkeys = <<EOF
ssh-rsa key
EOF
}

resource "proxmox_vm_qemu" "cloudinit-k3s-ansible" {
  target_node = "s1"
  desc        = "Cloudinit debian  - K3s Ansible"
  count       = 1
  vmid        = 300 + count.index  # Generera unika VMID baserat p   index
  onboot      = true
  clone       = "KubernetesNodeTemplate"
  agent       = 1

  os_type     = "cloud-init"
  cores       = 2
  sockets     = 1
  vcpus       = 0
  numa        = false
  cpu         = "host"
  memory      = 4096
  name        = "k3s-ansible-${count.index + 1}"

  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"

  # Setup the disk
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
          storage = "local-lvm"
          size    = 20
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=192.168.68.18${count.index + 1}/24,gw=192.168.68.1"
  ciuser    = "debian"
  serial {
    id   = 0
    type = "socket"
  }


sshkeys = <<EOF
ssh-rsa key
EOF
}