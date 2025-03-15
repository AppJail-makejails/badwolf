# badwolf

BadWolf is a minimalist and privacy-oriented WebKitGTK+ browser.

## Features:

* Privacy-oriented: No browser-level tracking, multiple ephemeral isolated sessions per new unrelated tabs, JavaScript off by default.
* Minimalist: Small codebase (~1 500 LoC), reuses existing components when available or makes them available.
* Customizable: WebKitGTK native extensions, Interface customizable through CSS.
* Powerful & Usable: Stable User-Interface; The common shortcuts are available, no vi-modal edition or single-key shortcuts are used.
* No annoyances: Dialogs are only used when required (save file, print, ...), javascript popups open in a background tab.

hacktivis.me/projects/badwolf

![badwolf logo](https://hacktivis.me/images/badwolf_2020-05-15_light.png)

## How to use this Makejail

```
INCLUDE options/network.makejail
INCLUDE gh+AppJail-makejails/badwolf

OPTION copydir=files
OPTION file=/etc/rc.conf
OPTION x11
```

Where `options/network.makejail` are the options that suit your environment, for example:

```
ARG network
ARG interface=badwolf

OPTION virtualnet=${network}:${interface} default
OPTION nat
```

The tree structure of the `files/` directory is as follows:

```
# tree -pug files/
[drwxr-xr-x root     wheel   ]  files/
└── [drwxr-xr-x root     wheel   ]  etc
    └── [-rw-r--r-- root     wheel   ]  rc.conf

1 directory, 1 file
```

Where `rc.conf` is your custom `rc.conf(5)` file, for example:

```
clear_tmp_X="NO"
```

The `rc.conf(5)` file above sets `clear_tmp_X` to `NO` to not remove the sockets and various related files before the jail starts.

Open a shell and run `appjail makejail` and `appjail start`:

```sh
appjail makejail -j badwolf -- --network development
appjail start badwolf
```

After Makejail builds the jail, you can run Badwolf using the `badwolf_open` custom stage:

```sh
xhost +
appjail run -s badwolf_open badwolf
# or to open a specific website:
appjail run -s badwolf_open -V URL=http://example.org badwolf
```

### Arguments

* `badwolf_tag` (default: `13.5`): see [#tags](#tags).
* `badwolf_ajspec` (default: `gh+AppJail-makejails/badwolf`): Entry point where the `appjail-ajspec(5)` file is located.

## Tags

| Tag        | Arch    | Version        | Type   |
| ---------- | ------- | -------------- | ------ |
| `13.5`     | `amd64` | `13.5-RELEASE` | `thin` |
| `14.2`     | `amd64` | `14.2-RELEASE` | `thin` |
