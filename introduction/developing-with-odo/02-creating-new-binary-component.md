
`ocdev catalog list`{{execute}}

```
The following components can be deployed:
- httpd
- nodejs
- perl
- php
- python
- ruby
- wildfly
```

`cd ~/backend`{{execute}}

`mvn package`{{execute}}

`ocdev component create wildfly backend --binary=target/backend-1.war`{{execute}}

