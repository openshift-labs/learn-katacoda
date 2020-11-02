

https://www.redhat.com/security/data/oval/v2/RHEL8/

``wget https://www.redhat.com/security/data/oval/v2/RHEL8/rhel-8.oval.xml.bz2``{{execute}}

``oscap-podman registry.access.redhat.com/ubi8/ubi:latest oval eval --report ./html/ubi-report.html rhel-8.oval.xml.bz2``{{execute}}

``podman run -p 80:8080 -id --name nginx -v /root/openscap_data:/opt/app-root/src/:Z registry.access.redhat.com/rhscl/nginx-114-rhel7 nginx -g 'daemon off;'``{{execute}}


https://[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/eval_remediate_report.html

https://www.youtube.com/watch?v=nQmIcK1vvYc
