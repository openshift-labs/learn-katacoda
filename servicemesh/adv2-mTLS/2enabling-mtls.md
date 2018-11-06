Now that Istio gateway is in place, you can enable mTLS by applying next Istio resources:

Check the file `istiofiles/authentication-enable-tls.yml`{{open}} that enables mTLS into tutorial namespace.

Check the file `istiofiles/destination-rule-tls.yml`{{open}} that makes services within tutorial namespace communicates with mTLS

Apply these files:

`istioctl create -f ~/projects/istio-tutorial/istiofiles/authentication-enable-tls.yml; \
istioctl create -f ~/projects/istio-tutorial/istiofiles/destination-rule-tls.yml `{{execute T1}}

Then you can run:

`curl ${GATEWAY_URL}`{{execute T1}}

**Note:** The command above migh return `customer => 503 upstream connect error or disconnect/reset before headers`. In that case, **repeat the command** `curl ${GATEWAY_URL}`{{execute T1}} until you see `customer => preference => recommendation v1 from 'b87789c58-mfrhr': X`

And you’ll see exactly the same but now the communication between the services has been secured. How can you check that?

By sniffing traffic between services, which is a bit more tedious, open a new terminal tab and run next command:

`CUSTOMER_POD=$(oc get pod | grep cust | awk '{ print $1}' ); \
oc exec -it $CUSTOMER_POD -c istio-proxy /bin/bash`{{execute T2}}

Inside pod shell execute:

`IP=$(ifconfig |grep inet |grep 10.|awk '{ print $2}'|sed -e 's/addr://g'); sudo tcpdump -vvvv -A -i eth0 '((dst port 8080) and (net '$IP'))'`{{execute T2}}

Now all communication that happens between customer service and preference service is dumped in the console.

So now go back to Terminal 1 and execute:

`curl ${GATEWAY_URL}`{{execute T1}}

Obviously, the response is exactly the same, but if you go to the Terminal 2 where you are executing tcpdump, you should see something like:

`14:24:55.078222 IP (tos 0x0, ttl 64, id 32578, offset 0, flags [DF], proto TCP (6), length 967)
    172.17.0.15.33260 > customer-7dcd544ff9-652ds.8080: Flags [P.], cksum 0x5bf5 (incorrect -> 0x595e), seq 2211080917:2211081832, ack 2232186801, win 391, options [nop,nop,TS val 5958433 ecr 5779275], length 915: HTTP
E....B@.@._........
......j...w.....[......`

Notice that you cannot see any detail about the communication since it happened through TLS.

Now, let’s disable TLS:

`istioctl delete -f ~/projects/istio-tutorial/istiofiles/authentication-enable-tls.yml; \
istioctl delete -f ~/projects/istio-tutorial/istiofiles/destination-rule-tls.yml`{{execute T1}}

And execute again: `curl ${GATEWAY_URL}`{{execute T1}}

And again check tcpdump output:

**Note:** You might need to wait some seconds and execute the command `curl ${GATEWAY_URL}`{{execute T1}} again until you see a clear communication happening.

`host: 0192.168.64.70:31380
user-agent: curl/7.54.0
accept: */*
x-forwarded-for: 172.17.0.1
x-forwarded-proto: http
x-envoy-internal: true
x-request-id: e5c0b90f-341b-9edc-ac3e-7dd8b33f0e8b
x-envoy-decorator-operation: customer.tutorial.svc.cluster.local:8080/
x-b3-traceid: ce289e960a639d11
x-b3-spanid: ce289e960a639d11
x-b3-sampled: 1`

Now, you can see that since there is no TLS enabled, the information is not shadowed but in clear.

## Clean Up

`istioctl delete -f ~/projects/istio-tutorial/istiofiles/gateway-customer.yml`{{execute T1}}

And finally you can restore the route:

`oc expose service customer`{{execute T1}}