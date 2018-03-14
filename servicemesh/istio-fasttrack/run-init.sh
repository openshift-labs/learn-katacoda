ISTIO_VERSION=0.5.0
BOOKINFO_VERSION=0.2.8

ssh root@host01 "until docker ps ; do echo . && sleep 2; done"

ssh root@host01 "docker pull istio/istio-ca:${ISTIO_VERSION}"
ssh root@host01 "docker pull istio/grafana:${ISTIO_VERSION}"
ssh root@host01 "docker pull istio/pilot:${ISTIO_VERSION}"
ssh root@host01 "docker pull istio/proxy_debug:${ISTIO_VERSION}"
ssh root@host01 "docker pull istio/proxy_init:${ISTIO_VERSION}"
ssh root@host01 "docker pull istio/examples-bookinfo-ratings-v1:${BOOKINFO_VERSION}"
ssh root@host01 "docker pull istio/examples-bookinfo-reviews-v2:${BOOKINFO_VERSION}"
ssh root@host01 "docker pull istio/examples-bookinfo-reviews-v1:${BOOKINFO_VERSION}"
ssh root@host01 "docker pull istio/examples-bookinfo-reviews-v3:${BOOKINFO_VERSION}"
ssh root@host01 "docker pull istio/examples-bookinfo-details-v1:${BOOKINFO_VERSION}"
ssh root@host01 "docker pull istio/examples-bookinfo-productpage-v1:${BOOKINFO_VERSION}"
ssh root@host01 "docker pull istio/mixer:${ISTIO_VERSION}"
ssh root@host01 "docker pull istio/servicegraph:${ISTIO_VERSION}"
ssh root@host01 "docker pull openzipkin/zipkin:latest"
ssh root@host01 "docker pull prom/prometheus:v2.0.0"
ssh root@host01 "docker pull prom/statsd-exporter"
ssh root@host01 "docker pull alpine"
ssh root@host01 "oc adm policy add-cluster-role-to-user cluster-admin admin"
