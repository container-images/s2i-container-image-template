Extending image
---------------------------------

This image can be extended using
[source-to-image](https://github.com/openshift/source-to-image).

For example to build customized image `my-image:x.y`
with configuration in `~/image-configuration/` run:


```
$ s2i build ~/image-configuration/ image:x.y my-image:x.y
```

The directory passed to `s2i build` should contain one or more of the
following directories:

##### `service-config/`

when running `run-service` command contained
`service.conf` file is used for `service` configuration


##### `pre-init/`

contained shell scripts (`*.sh`) are sourced before `service` is started

##### `init/`

contained shell scripts (`*.sh`) are sourced when `service` is
started

----------------------------------------------

During `s2i build` all provided files are copied into `/opt/app-root/src`
directory in the new image. If some configuration files are present in
destination directory, files with the same name are overwritten. Also only one
file with the same name can be used for customization and user provided files
are preferred over default files in `/usr/share/container-scripts/`-
so it is possible to overwrite them.

Same configuration directory structure can be used to customize the image
every time the image is started using `docker run`. The directory have to be
mounted into `/opt/app-root/src/` in the image (`-v
./image-configuration/:/opt/app-root/src/`). This overwrites customization
built into the image.

Example
---------------------------------

This repository contains the example to demonstrate the workflow.

Build the s2i builder image:
```
$ make build
```

Build new extended image:
```
$ s2i build ./examples/extending-image/ image:x.y new-image
```

Run new image:
```
$ docker run new-image
```

You should see that two extra scripts were executed : `init-extended.sh` and `pre-init-extended.sh`.
The [set-config.sh](./root/usr/share/container-scripts/pre-init/set-config.sh) script takes care about using correct configuration file for the service.
In this example configuration file from examples folder is used in the container, not the default one.

Credits
---------------------------------

Pattern of creating s2i images is inspired by [sclorg MongoDB container.](https://github.com/sclorg/mongodb-container)

Development Notes
---------------------------------

This repository is temporary and hopefully will be merged with [container-image-template](https://github.com/container-images/container-image-template) in the future.
