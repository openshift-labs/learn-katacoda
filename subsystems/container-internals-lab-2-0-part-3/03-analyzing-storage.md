
[What the heck is d_type](https://linuxer.pro/2017/03/what-is-d_type-and-why-docker-overlayfs-need-it/)

``docker info | grep Storage``{{execute}}
``docker info | grep Root``{{execute}}
``podman info | grep -A3 Graph``{{execute}}
``tree /var/lib/docker/overlay2``{{execute}}
``tree /var/lib/containers/storage``{{execute}}
