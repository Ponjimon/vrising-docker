
# V Rising Docker Image
This is a Docker image for V Rising that uses Wine to run it.

> There is no dedicated server for Linux yet, but there will be one [soon™](https://github.com/StunlockStudios/vrising-dedicated-server-instructions/issues/1#issuecomment-1129496258).  
> As soon as there is one, this image will be updated accordingly.

## Usage
You can build the Docker image yourself (see below) or use the pre-built image:

 ```console
docker pull public.ecr.aws/r0w6f3t3/vrising:latest
 ```

To run it, you have to mount a volume and attach it to `/vrising/server-data`.
Inside that volume, the server will store the save data and settings.


 ```console
 docker run -it -p 27015:27015/udp -p 27016:27016/udp -v /home/vrising/server-data:/vrising/server-data public.ecr.aws/r0w6f3t3/vrising:latest
 ```
 
 Alternatively, you can use `docker-compose`. Simply run `docker-compose up -d` to spin up a container. The `docker-compose.yaml` file assumes that there is a directory `${HOME}/vrising-server` in which the container will mount a volume and store the saves where you can add your custom settings.

Obviously, you would have to adapt the ports and/or volume name if you changed the settings.

> **Note**: If the local user's UID/GID is **not** 1000, you need to run the container like this:
> 
> ```console
> docker run -it -p 27015:27015/udp -p 27016:27016/udp -e LOCAL_USER_ID=`id -u $USER` -e LOCAL_GROUP_ID=`id -g $USER` -v /home/vrising/server-data:/vrising/server-data public.ecr.aws/r0w6f3t3/vrising:latest
> ```
>
> This makes sure that there won't be any permission conflicts.

### Step by Step

We assume we're logged in to a Linux/Ubuntu machine under the user `vrising`.

1. Pull latest Docker image:

     ```console
     docker pull public.ecr.aws/r0w6f3t3/vrising:latest
     ```
2. Create a folder anywhere on your system where you want the save files and the server settings to be. Let's assume the home directory:

     ```console
     mkdir -p /home/vrising/server-data/Settings
     ```
3. Put your desired settings into the newly created `Settings` folder. Refer to the [official instructions](https://github.com/StunlockStudios/vrising-dedicated-server-instructions) to find out which settings (for example `ServerHostSettings.json`)
4. Start the server:

     ```console
     docker run -it -p 27015:27015/udp -p 27016:27016/udp -v /home/vrising/server-data:/vrising/server-data public.ecr.aws/r0w6f3t3/vrising:latest
     ```

### Build your own

Feel free to modify the [Dockerfile](https://github.com/Ponjimon/vrising-docker/blob/main/Dockerfile) and build it:

```console
docker build -t my-vrising-server:latest .
docker push my.regist.try/my-vrising-server:latest
```

> **Warning**: Do not actually run the command above as is. It's just for demonstration purposes.

## Good to Know

The server version (using SteamCMD) is baked into the image. So the image has to be rebuilt everytime the developers publish a new server version.

## Credits

Props to [@fragsoc](https://github.com/fragsoc) for the inspiration based on [fragsoc/steamcmd-wine-xvfb](https://github.com/FragSoc/steamcmd-wine-xvfb-docker).
