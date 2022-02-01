# Arch Installation

## Connection to the internet

1. Using ```iwctl``` :
  
       station wlan0 connect-hidden SSID 
 
2. Updating System Clock:

       timedatectl set-ntp true

## Partitions

3. Partitioning (no need since it's already done, format root) or ```cfdisk /dev/sdX```:
      
       fdisk -l 
       mkfs.ext4 /dev/root_partition 
  
  
## Mounting

4. Mounting the home, root, and ESP/EFI (create dirs if not found):
      
       mount /dev/nvme0n1p5 /mnt
       mount /dev/nvme0n1p6 /mnt/home
       mount /dev/nvme0n1p1 /mnt/EFI ====> may not be needed
 
## Installing the kernel

5. Installing linux and other packages:

       pacstrap /mnt base linux linux-firmware vim 
         
6. Generating fstab:
     
       genfstab -U /mnt >> /mnt/etc/fstab
       
7. Change root:

       chroot /mnt

## Extras

8. Installing other packages:

       pacman -S linux-lts linux-lts-headers base-devel wireless_tools networkmanager wpa_supplicant netctl dialog sudo
       
9. Enable network manager:
       
       systemctl enable NetworkManager
      
10. Localization (uncomment en_US-UTF-8 in /etc/locale.gen) then generate the locale by ```locale-gen```.
11. Create the root user (passwd).
12. Adding the user ```useradd -m -g users -G wheel none```.
13. Change the default editor ```Export EDITOR=vim```.
14. Uncomment the wheel in the sudoers file.
15. Configure the hostname : ```echo none > /etc/hostname```
16. Edit the hosts file ```vim /etc/hosts```:

        127.0.0.1	localhost
        ::1		localhost
        127.0.1.1	[your_hostname]

## Grub 

17. Installing the grub:
    
        pacman -S grub efibootmgr os-prober
        
        mkdir /boot/efi
    
        mount /dev/nvme /boot/efi
    
        grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
   
        grub-mkconfig -o /boot/grub/grub.cfg
