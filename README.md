# Getting started
## Dependencies
- GNU Make (`make` Debian's package)
- [Docker Compose](https://github.com/docker/compose) (v2 and higher)

In your `/etc/docker/daemon.json`, make sure to enable ipv6 and buildkit. Here is the config I use:
```json
{
	"storage-driver": "btrfs",
	"ipv6": true,
	"fixed-cidr-v6": "fd00:d0cc:e700:defa::/64",
	"default-address-pools": [
		{
			"base": "10.0.0.0/8",
			"size": 24
		},
		{
			"base": "fd00:d0cc:e700:1111::/64",
			"size": 80
		}
	],
	"features": {
		"buildkit": true
	}
}
```

- `golang` (I use version 2:1.19~1~bpo11+1 from Debian bullseye's backports), to build NextMN-UPF.

## Build
The current version use [NextMN-UPF](https://github.com/louisroyer/nextmn-upf), an experimental UPF I developped. It may not be very stable, and breaking changes may still happen.
For the moment, to be able to use it you need to build it appart and put the binary at `../nextmn-upf/nextmn-upf` from this directory.

If you want to use Free5GC's UPF, some commented lines are in `free5gc/Dockerfile`. You can uncomment them to build the image (don't forget to also do replacements in `docker-compose.yaml`). Since Free5GC has recoded their UPF from C to Golang, I had not tested it well, so expect to run into some issues. Main difference between Free5GC's UPF and NextMN's UPF: Free5GC use GTP kernel module (you have to install the module [gtp5g](https://github.com/free5gc/gtp5g)), while NextMN runs entirely in userland.

- `docker compose --profile debug build`
Some Docker Images are weekly updated on [DockerHub](https://hub.docker.com/search?q=louisroyer) (RAN and debug containers), for the moment you will have to build most of them because I consider them not yet ready to upload on DockerHub.
The above command will download images online and build the missing ones from Dockerfile hosted on this repository. To use your own images (for example a debug image with more tools), replace it in `docker-compose.yaml`. 

## License
- Dockerfiles, configuration, scripts, documentation, and in a general fashion all files directly hosted in this git repository are under MIT license.
- For softwares distributed in docker images that I host on DockerHub, refer to licenses of such softwares (I package them using `.deb` so licenses are indicated in `/usr/share/doc/*/copyright`).
- For softwares that **you** download while building **your own** images, please refer to corresponding projects. They are under various FOSS licenses, but I don't distribute their source code/binaries. If you redistribute them it is your own responsability to do it under their license terms.

## Run

```text
# Start containers
$ make u

# Run testbed (press enter after each test)
$ make test

# Enter debug container of ue1
$ make t/ue1

# Stop containers
$ make d
```

# Issues
If you have any issue, feel free to open a ticket in the bugtracker.
Please note this repository is mainly used by myself to do experimentations on MEC and 5G, and bugs may appear, especially if you modify configuration files in a way I have not tested before.
Also, some features may not be well documented yet.
