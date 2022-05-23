
# V Rising Docker Image
This is a Docker image for V Rising that uses Wine to run it. Props to [@fragsoc](https://github.com/fragsoc) for making this possible by using [fragsoc/steamcmd-wine-xvfb](https://github.com/FragSoc/steamcmd-wine-xvfb-docker).

> There is no dedicated server for Linux yet, but there will be one [soon™](https://github.com/StunlockStudios/vrising-dedicated-server-instructions/issues/1#issuecomment-1129496258).  
> As soon as there is one, this image will be updated accordingly.

## Usage
You can build the Docker image yourself (see below) or use the pre-built image:

 `docker pull public.ecr.aws/r0w6f3t3/vrising:latest`

To run it, you have to mount a volume and attach it to `/vrising/server-data`.
Inside that volume, the server will store the save data and settings.

`docker run -it -p 27015:27015/udp -p 27016:27016/udp -v /home/vrising/server-data:/vrising/server-data public.ecr.aws/r0w6f3t3/vrising:latest`

Obviously, you would have to adapt the ports and/or volume name if you changed the settings.

Or you can use `docker-compose` and run `docker-compose up -d`. The `docker-compose.yaml` file assume that there is a directory `vrising-server` under `${HOME}` as it will be where the server settings and saves are stored.

Remember to open the ports 27015 and 27016 in `UDP` in your firewall or clients won't be able to reach your docker container.

### Step by Step

We assume we're logged in to a Linux/Ubuntu machine under the user `vrising`.

1. Pull latest Docker image:

    `docker pull public.ecr.aws/r0w6f3t3/vrising:latest`
2. Create a folder anywhere on your system where you want the save files and the server settings to be. Let's assume the home directory:

    `mkdir -p /home/vrising/server-data/Settings`
3. Put your desired settings into the newly created `Settings` folder. Refer to the [official instructions](https://github.com/StunlockStudios/vrising-dedicated-server-instructions) to find out which settings (for example `ServerHostSettings.json`)
4. Start the server:

    `docker run -it -p 27015:27015/udp -p 27016:27016/udp -v /home/vrising/server-data:/vrising/server-data public.ecr.aws/r0w6f3t3/vrising:latest`

### Build your own

Feel free to modify the [Dockerfile](https://github.com/Ponjimon/vrising-docker/blob/main/Dockerfile) and build it:

```
docker build -t my-vrising-server:latest .
docker push my.regist.try/my-vrising-server:latest
```

> **Note**: Do not actually run the command above as is. It's just for demonstration purposes.

## Good to Know

The server version (using SteamCMD) is baked into the image. So the image has to be rebuilt everytime the developers publish a new server version.
