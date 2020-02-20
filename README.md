# EdgeX Demo using Kuma Service Mesh
I have been looking for a way to manage securing the service to service communications within EdgeX without requiring any code changes on the micro-services. I also wanted have this all up and running inside of Docker containers given that it is relatively easy to deploy containers. This demo can be done utilizing services running within the OS, however, at this time, this demo is 100% based on deploying within Docker containers.

To read up on Kuma, you can visit their [web site](https://kuma.io/). Kuma is built by the lovely peeps that build [Kong](https://konghq.com/kong/).

## Run The Demo
In order to run the demo, you need to have both `docker` and `docker-compose` installed. The Docker Install pages should be able to help you there. Once you've got those installed, you can run the following from this directory:

```bash
docker-compose -f edgex-docker-compose.yml up --build -d
```

There are 4 docker images that will get built - kuma/base-image, kuma/kuma-cp, kuma/kuma-dp, and kuma/kumactl. The base image is used to download the Ubuntu based binaries from [Kuma.io](https://kuma.io) and then used as part of a quasi-multi-stage-build "copy" in their respective docker files. 

## What Do I Do Now?
Well, typically in the past, I'd tell you to go grab a beer, but now you've got to see it actually working.