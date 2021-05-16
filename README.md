# My-Personal-Tweaks
This is my pc/laptop personal tweaks and fixes for longer battery life and maximum performance.

Since i am using Linux, i use powerTDP; a great tool to monitor the battery life.

## Disable GPU
fu** nVidia!, since it never worked on linux and i struggled to fix this, i've decided to disable that trash.


```$ lspci | grep "VGA"```

```
   01:00.0 VGA compatible controller: NVIDIA Corporation TU117M (rev a1)
   05:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Renoir (rev c7)
```

List installed display drivers and make sure that nivida drivers are not there:
NOTE: mhwd is manjaro only!
```$ mhwd -li```

```
> Installed PCI configs:
--------------------------------------------------------------------------------
                  NAME               VERSION          FREEDRIVER           TYPE
--------------------------------------------------------------------------------
           video-linux            2018.05.04                true            PCI

```


Make sure to use : ```nouveau.modeset=0``` in the grub, just in case if something went wrong.

Sometimes ScreenTearing and flickering happens 

##### To fix Tearing :

Create this file and use ```TearFree```, to fix tearing problem 
```touch /etc/X11/xorg.conf.d/20-amdgpu.conf```
```
Section "Device"
	Identifier "AMD"
	Driver "amdgpu"
	Option "TearFree" "true"
EndSection
```

##### To fix Flickering :

For now i don't have a clue how to permanently fix it, since i am sure what exactly the reason for this (i think it's the new amd gpu, which is kernel related):

Fix (run multiply times):
```xset dpms force off```

## Keyboard

I like using my keyboard, so i have a lot of keybinding, check out my [wm](https://github.com/AYehia0/Dotfiles/blob/master/sxhkd/sxhkdrc)

one thing, i don't use CAPS lock key(vim), instead it's now esc : ```setxkbmap -option caps:escape ```

## Poweroff

change the power button handler ```#HandlePowerKey=poweroff``` to ```ignore``` to prevent accidental presses:

``` $ vim /etc/systemd/logind.conf```

