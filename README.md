# Docker LTB SSP&mdash;LDAP Toolbox Self Service Password containerized

This project provides a containerized version of the [LDAP Toolbox Service Password] application based on [Docker].

The Docker image is based on the [light base image by osixia]&mdash;according to their principle: We dockerize, everything!

This is an early version of the image, which hasn't been released to the [Docker Hub]. This is definitely planned for the first offical release.

## Building

As the image hasn't been released, you have to build it yourself.
In order to do this, first you have to make sure that all prerequisites are met and then you can clone the repository to your computer.

### Prerequisties
1. You need to install [Docker Community Edition]
2. You need to install [git]

### Clone the repository

Just issue the following commmand for cloning the repository:

```bash
$ git clone https://github.com/moritzrupp/Docker-LTB-SSP.git
```

### Build the image

Now it is time to build the image. It is very helpful to first familiarize yourself with docker in case you haven't done this yet.

Navigate into the cloned repository:

```bash
$ cd <path/to/folder>/Docker-LTB-SSP/
```

Then you can easily build the image based on the Dockerfile:

```bash
$ docker build -t moritzrupp/docker-ltb-ssp --rm .
```

Done. You have successfully built the Docker LTB SSP image.

## Usage

The image provides the following environmental variables:

### Startup variables

1. ```LTBSSP_LDAP_URL```
2. ```LTBSSP_USER```
3. ```LTBSSP_PASSWORD```
4. ```LTBSSP_BASE```

### Configuration variables with default values

5. ```LTBSSP_SHADOW_LAST_CHANGE: true```
6. ```LTBSSP_HASH: auto```

You can simply set those variables with the Docker command for running the image:

```bash
$ docker run --env LTBSSP_LDAP_URL="ldap.example.org" --env LTBSSP_USER="manager" \
--env LTBSSP_PASSWORD="VerySecretPassword" \
--env LTBSSP_BASE="dc=exmample,dc=org" \
-p 80:80 --detach moritzrupp/docker-ltb-ssp:latest
```

You can also easily link your own __my-env.yaml__ or __my-env.startup.yaml__ files into the container:

```bash
$ docker run --volume /data/ltb-ssp/environment:/container/environment/01-custom \
-p 80:80 --detach moritzrupp/docker-ltb-ssp:latest
```

A third option is to link you own config file for LTB SSP. Just download the [default config file] for LTB SSP, copy it into a custom directory (e.g. ```/data/ltb-ssp/conf/config.inc.php```) and link this directory to the container:

```bash
$ docker run --volume /data/ltb-ssp/environment:/container/environment/01-custom \
--volume /data/ltb-ssp/conf:/var/www/ltb-ssp/conf \
-p 80:80 --detach moritzrupp/docker-ltb-ssp:latest
```

It is important that you have a running LDAP service which can be used by Self Service Password.

# Contact

If you want to contact the developer write an email to [Moritz Rupp]. In case of questions or problems, don't hesitate to [open an issue].

A contribution guide will be published with the first offical release.

# Changelog

The changelog can be found [here].

# License

This work is lincesed under [the MIT license].

[LDAP Toolbox Service Password]: https://ltb-project.org/documentation/self-service-password
[Docker]: https://www.docker.com/
[light base image by osixia]: https://github.com/osixia/docker-light-baseimage
[Docker Hub]: https://hub.docker.com/
[Docker Community Edition]: https://docs.docker.com/engine/installation/
[git]: https://git-scm.com/
[default config file]: https://github.com/ltb-project/self-service-password/blob/master/conf/config.inc.php
[open an issue]: https://github.com/moritzrupp/Docker-LTB-SSP/issues/new
[Moritz Rupp]: mailto:moritz.rupp@gmail.com
[here]: https://github.com/moritzrupp/Docker-LTB-SSP/blob/master/CHANGELOG.md
[the MIT license]: https://github.com/moritzrupp/Docker-LTB-SSP/blob/master/LICENSE