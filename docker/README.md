# Kentik Lite

This is Kentik in a box. Grab data via pcap from your host, view it in Grafana by way of Promethius.

## Quickstart:

### Define the interface you want to listen for traffic on:
`export KENTIK_INTERFACE=eth0`

### Pull down some supporting data files:
`docker-compose run --entrypoint fetch ktranslate`

### Fix file permissions.
`chmod a+w grafana/data`

`chmod a+w prometheus/data`

### Run the fleet.
`docker-compose up`

### And start exploring!
Log into grafana at http://localhost:3000 with

`admin/therealdeal`

## Tech Stack
* KProbe (https://github.com/kentik/kprobe)
* KTranslate (https://github.com/kentik/ktranslate)
* Kappa (https://github.com/kentik/kappa)
* Mock Auth
* Prometheus
* Grafana

Want more? Sign up for the whole hog at https://kentik.com.
