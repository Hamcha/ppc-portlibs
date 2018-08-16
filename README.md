# Portlibs for devkitPPC

It's kinda like [3ds_portlibs](https://github.com/devkitPro/3ds_portlibs) but for Gamecube and Wii. The big libraries are bundled with dkP so what's left is what I personally need for my projects.

Default install dir is `$DEVKITPRO/ppc-portlibs`, edit `build.sh` to change that

## Usage

```
./build.sh <library> [<library2> ..]
```

You can use the extended syntax (`bash build.sh <target>`) on Windows if dkP MSYS is in %PATH%.


## Available libraries

Currently supports:
 - [EntityX](https://github.com/alecthomas/entityx) using `entityx`

Nothing else planned right now.

## Licenses

The licenses for the project compiled by this project can be found under the `licenses` folder in the following files:
 - [EntityX](https://github.com/alecthomas/entityx) -> `LICENSE-entityx.txt` (MIT)