ISTIO=0.6.0
BOOKINFO=0.2.8
BOOKINFOv2=1.5.0
docker pull istio/grafana:$ISTIO
docker pull istio/istio-ca:$ISTIO
docker pull istio/grafana:$ISTIO
docker pull istio/pilot:$ISTIO
docker pull istio/proxy_debug:$ISTIO
docker pull istio/proxy_init:$ISTIO
docker pull istio/mixer:$ISTIO
docker pull istio/servicegraph:$ISTIO
docker pull openzipkin/zipkin:latest
docker pull jaegertracing/all-in-one:latest
docker pull prom/prometheus:v2.0.0
docker pull prom/statsd-exporter
docker pull alpine
docker pull istio/examples-bookinfo-ratings-v1:$BOOKINFO
docker pull istio/examples-bookinfo-reviews-v2:$BOOKINFO
docker pull istio/examples-bookinfo-reviews-v1:$BOOKINFO
docker pull istio/examples-bookinfo-reviews-v3:$BOOKINFO
docker pull istio/examples-bookinfo-details-v1:$BOOKINFO
docker pull istio/examples-bookinfo-productpage-v1:$BOOKINFO

docker pull istio/examples-bookinfo-ratings-v1:$BOOKINFOv2
docker pull istio/examples-bookinfo-reviews-v2:$BOOKINFOv2
docker pull istio/examples-bookinfo-reviews-v1:$BOOKINFOv2
docker pull istio/examples-bookinfo-reviews-v3:$BOOKINFOv2
docker pull istio/examples-bookinfo-details-v1:$BOOKINFOv2
docker pull istio/examples-bookinfo-productpage-v1:$BOOKINFOv2
