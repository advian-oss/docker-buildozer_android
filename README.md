# Buildozer for android

Build base image with NDK and stuff pre-pulled into layer, it will auto-accept the NDK license for you:

    docker build --ssh default --target devel_shell -t buildozer4a:devel_shell .

Then you can get a (Oh-My-zsh) shell with your current working directory mounted:

    docker run --rm -it -v `pwd`":/app" buildozer4a:devel_shell

If you add `--privileged` (or manually map correct USB devices) Android Debug Bridge might work...

Or you can make your own `Dockerfile` that uses `FROM buildozer4a:devel_shell as myapp`

## Buildozer caches

The local caches made when building the minimal app (to get dependencies and stuff) might
be speed up building your app too, copy them in the devel_shell with

    rsync -aP /minimalapp/.buildozer ./
