##########################
# K3s Master-noder (2 st)
##########################

resource "proxmox_vm_qemu" "cloudinit-k3s-master" {
  count       = 2
  name        = "k3s-master-${count.index + 1}"                       # Namn på VM:n
  desc        = "Cloudinit Debian - K3s Master ${count.index + 1}"   # Beskrivning i Proxmox GUI
  target_node = var.proxmox_host                                     # Proxmox-host där VM:n skapas
  clone       = var.template_name                                    # Namn på Cloud-Init template som används som bas
  vmid        = 100 + count.index                                    # Unikt VM-ID för varje master
  onboot      = true                                                 # Starta automatiskt vid boot
  agent       = 1                                                    # Aktivera qemu-agent
  os_type     = "cloud-init"                                         # Använd Cloud-Init
  memory      = 4096                                                 # RAM i MB
  sockets     = 1                                                    # Antal CPU-socklar
  cores       = 2                                                    # Antal kärnor per socket
  vcpus       = 0                                                    # Låt Proxmox hantera vCPU-balansering
  cpu_type    = "host"                                               # Använd fysisk CPU-konfiguration
  numa        = false                                                # NUMA avstängt
  scsihw      = "virtio-scsi-pci"                                    # SCSI controller-typ
  bootdisk    = "scsi0"                                              # Disk som används för boot

  # Disk-konfiguration
  disks {
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"                                      # Cloud-Init disk
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = 20                                               # Rootdisk-storlek i GB
          storage = "local-lvm"
        }
      }
    }
  }

  # Nätverkskonfiguration
  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"                                                 # Virtuell brygga i Proxmox
  }

  ipconfig0 = "ip=192.168.68.15${count.index + 1}/24,gw=192.168.68.1" # Statiska IP-adresser för masters
  ciuser    = var.ciuser                                              # Användare som definieras i variables.tf
  sshkeys   = local.ssh_key                                          # Publik nyckel för SSH-access

  serial {
    id   = 0
    type = "socket"                                                  # Krävs för seriell konsolåtkomst
  }
}

##########################
# K3s Worker-noder (3 st)
##########################

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
  memory      = 8096
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
          size    = 20                                               # Något mindre disk än master
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    id     = 0
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

##########################
# Ansible Kontrollmaskin
##########################

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
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=192.168.68.181/24,gw=192.168.68.1"                 # Fast IP för Ansible-värden
  ciuser    = var.ciuser
  sshkeys   = local.ssh_key

  serial {
    id   = 0
    type = "socket"
  }
}
