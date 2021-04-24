#!/bin/bash
echo "Updating"
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
echo "Installing software"
sudo apt install -y qemu qemu-kvm libvirt-daemon libvirt-clients bridge-utils virt-manager ovmf make
echo "Installing Virsh-Api-Server"
sudo git clone https://github.com/yoanndelattre/Virsh-Api-Server.git /Virsh-Api-Server
cd /Virsh-Api-Server
sudo make install
cd ~/
echo "Downloading ISOs"
sudo wget -O /var/lib/libvirt/images/virtio-win.iso https://kvm-resources.s3.fr-par.scw.cloud/virtio-win-0.1.185.iso
sudo wget -O /var/lib/libvirt/images/windows10.iso https://kvm-resources.s3.fr-par.scw.cloud/Windows10_custom_template.iso
echo "Creating vm volume"
sudo mkdir -p /media/vm_storage
sudo virsh pool-define-as --name vm_storage --type dir --target /media/vm_storage
sudo virsh pool-autostart vm_storage
sudo virsh pool-start vm_storage
sudo qemu-img create -f raw /media/vm_storage/win10.img 128G
echo "Creating vm"
sudo wget -O /etc/libvirt/qemu/Windows10.xml https://gitlab.com/yoanndelattre/windows-deployer/-/raw/master/Ionos/vm-script/assets/windows10_vm_template.xml
sudo virsh define /etc/libvirt/qemu/Windows10.xml
echo "Enabling autostart vm"
sudo virsh autostart Windows10
echo "Starting vm"
sudo virsh start Windows10