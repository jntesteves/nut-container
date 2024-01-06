# NUT container

An OCI container image to run blawar's [NUT](https://github.com/blawar/nut) as a server on Linux.

## Usage

The container can be launched with a container runtime like Docker or Podman, for example:

```
podman run -d --name=nut -p 9000:9000 -v nut-data:/app/titledb:rw -v /path/to/roms:/roms:ro -e USERNAME=guest -e PASSWORD=guest jntesteves/nut
```

You should replace `/path/to/roms` with the path to the directory containing your ROM dumps, and preferably set USERNAME and PASSWORD to safer values. These are the username and password that you will use in [Tinfoil](https://tinfoil.io/) to connect to your NUT server.

If you already have a `users.conf` file with all your username-password pairs, you can use it instead of passing the USERNAME and PASSWORD environment variables on the command-line, just mount it into the container using a volume:

```
podman run -d --name=nut -p 9000:9000 -v nut-data:/app/titledb:rw -v /path/to/roms:/roms:ro /path/to/users.conf:/app/conf/users.conf:ro jntesteves/nut
```

While the container is up, a background process will keep scanning for new ROMs every 30 seconds by default. This timer can be overridden with the variable `-v SCAN_WAIT=30`, with the value in seconds. This process is done by calling the public HTTP API. The user passed in the USERNAME variable is used for this process. If a USERNAME isn't provided on the command-line, the first user found in the `users.conf` file is used instead.

## Building the image

Clone this repository with git. The image can be built locally using the provided ./make script. If omitted, TAG will be `nut` by default.

```
# Build the image
./make

# Build the image, with optional TAG-name
./make TAG=my-registry/nut:latest

# Launch in a disposable container
./make run ROMS_PATH=/path/to/roms USERNAME=guest PASSWORD=guest TAG=my-registry/nut:latest
```

## License

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

See [UNLICENSE](UNLICENSE) file or http://unlicense.org/ for details.
