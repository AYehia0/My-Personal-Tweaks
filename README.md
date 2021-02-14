# My-Personal-Tweaks
This is my pc/laptop personal tweaks and fixes for longer battery life and maximum performance.

Since i am using Linux, i use powerTDP; a great tool to monitor the battery life.

## Disable GPU
fu** nVidia!, since it never worked on linux and i struggled to fix this, i've decided to disable that trash.


```$ lspci | grep "VGA"```

```01:00.0 VGA compatible controller: NVIDIA Corporation TU117M (rev a1)
05:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Renoir (rev c7)```

