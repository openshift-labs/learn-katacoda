ISTIO=1.0.5
BOOKINFO=1.6.0
BOOKINFOv2=1.8.0
KIALI=v0.9.0
docker pull istio/grafana:$ISTIO
docker pull istio/istio-ca:$ISTIO
docker pull istio/grafana:$ISTIO
docker pull istio/pilot:$ISTIO
docker pull istio/proxy_debug:$ISTIO
docker pull istio/proxy_init:$ISTIO
docker pull istio/proxyv2:$ISTIO
docker pull istio/citadel:$ISTIO
docker pull istio/galley:$ISTIO
docker pull istio/sidecar_injector:$ISTIO
docker pull istio/mixer:$ISTIO
docker pull istio/servicegraph:$ISTIO
docker pull gcr.io/istio-release/galley:$ISTIO
docker pull gcr.io/istio-release/grafana:$ISTIO
docker pull gcr.io/istio-release/citadel:$ISTIO
docker pull gcr.io/istio-release/mixer:$ISTIO
docker pull gcr.io/istio-release/servicegraph:$ISTIO
docker pull gcr.io/istio-release/sidecar_injector:$ISTIO
docker pull gcr.io/istio-release/proxyv2:$ISTIO
docker pull gcr.io/istio-release/pilot:$ISTIO
docker pull openzipkin/zipkin:latest
docker pull jaegertracing/all-in-one:latest
docker pull prom/prometheus:v2.0.0
docker pull prom/prometheus:v2.3.1
docker pull prom/statsd-exporter
docker pull prom/statsd-exporter:v0.6.0
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

docker pull kiali/kiali:$KIALI
