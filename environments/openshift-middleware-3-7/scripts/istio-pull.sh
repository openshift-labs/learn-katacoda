ISTIO=0.4.0
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
