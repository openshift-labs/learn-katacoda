

``wget https://www.redhat.com/security/data/oval/v2/RHEL8/rhel-8.oval.xml.bz2``{{execute}}

``podman run p 80:80 -id -v /root/openscap_data:/var/lib/html/ registry.access.redhat.com/rhscl/nginx-114-rhel7 nginx -g 'daemon off;'``{{execute}}

https://[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com

https://www.youtube.com/watch?v=nQmIcK1vvYc
