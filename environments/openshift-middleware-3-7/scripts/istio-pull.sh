ISTIO=0.4.0
BOOKINFO=0.2.8
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
