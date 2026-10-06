# badwolf

BadWolf is a minimalist and privacy-oriented WebKitGTK+ browser.

Features:

* Privacy-oriented: No browser-level tracking, multiple ephemeral isolated sessions per new unrelated tabs, JavaScript off by default.
* Minimalist: Small codebase (~1 500 LoC), reuses existing components when available or makes them available.
* Customizable: WebKitGTK native extensions, Interface customizable through CSS.
* Powerful & Usable: Stable User-Interface; The common shortcuts are available, no vi-modal edition or single-key shortcuts are used.
* No annoyances: Dialogs are only used when required (save file, print, ...), javascript popups open in a background tab.

hacktivis.me/projects/badwolf

<img src="https://raw.githubusercontent.com/AppJail-makejails/badwolf/refs/heads/main/badwolf/badwolf.png" width="30%" height="auto" alt="badwolf logo">

## How to use this AppJail

For each new release, the AppJail can be obtained as an asset. [`sysutils/bin`](https://freshports.org/sysutils/bin) is a binary manager capable of downloading, installing, and updating, making it well-suited for our purposes.

```console
$ doas pkg install -y bin
```

Install the latest version of this AppJail by running the following command:

```console
$ mkdir -p ~/bin
$ bin install https://github.com/appjail-makejails/badwolf
```

Or update it if it is already installed:

```console
$ bin update badwolf.appjail
```

Assuming `~/bin` is in your `PATH`, you can run the AppJail simply by using the following command:

```console
$ badwolf.appjail
```

Remember that when running an AppJail in portable mode, you must install the key used to verify the binary:

```console
$ cat << "EOF" | doas x11appjail trust dtxdf@disroot.org -
untrusted comment: dtxdf@disroot.org (x11appjail) public key
RWSZbdqRaZVSgICvhui+nrVbXbWw25jyZx/3lhaPzSmVi1Pgvk2DAB1h
EOF
$ x11appjail trusted
KEY                                                                   COMMENT
37e1a7da5478a29ec3d38ecb14919b107beab67cc0de0b473b5b018f018e1ccb.pub  dtxdf@disroot.org (x11appjail) public key
```



### User Attributes

| Name | Description |
| --- | --- |
| `enable_3d` | This permission will execute the application using VirtualGL and make hardware acceleration-related devices visible.|
| `ephemeral` | Mark the jail as ephemeral. See `ephemeral` option in `appjail-quick(1)` for details.<br><br>Although the jail may be destroyed, its data is preserved in the user directory (see `${X11APPJAIL_USERDIR}` in `x11appjail-spec(5)`).<br>|
| `sound` | This permission will make sound-related devices visible.|
| `usb` | This permission will make usb-related devices visible.|
| `virtualgl-display` | If the user has the `enable_3d` permission, this specifies the display or EGL device to be used for 3D rendering. Since using EGL is the only logical choice for this project, the default value is `egl`. In multi-GPU environments, it is possible to specify a particular device.|
| `webcam` | This permission will make webcam-related devices visible.|

### System Attributes

| Name | Description |
| --- | --- |
| `labels` | A space-separated list of label names.|
| `network-mode` | Network mode. Default is `none`.<br><br>There are three modes:<br><br>1. `virtualnet`: This option is recommended, as it provides isolation and allows a more fine-grained control. It's necessary to install and configure AppJail on the host, as specified in the "[Getting Started](https://appjail.readthedocs.io/en/latest/getting-started/)" guide.<br>2. `inherit`: This mode does not provide network isolation. From a networking perspective, it is exactly the same as running the application on the host.<br>3. `none`: Completely disable the network stack.<br>|
| `oci-from` | Location of OCI image.|
| `oci-tag` | OCI image tag.|
| `per-labels` | The value of the label.|
| `per-oci-from` | Same as `oci.from`, but by application. It takes precedence when defined.|
| `per-oci-tag` | Same as `oci.tag`, but by application. It takes precedence when defined.|
| `perms` | A space-separated list of "permissions" granted to a specific user.<br><br>The implemented "permissions" are presented below:<br><br>* `enable_3d`<br>* `webcam`<br>* `usb`<br>* `sound`<br><br>For a description of any of them, consult `${X11APPJAIL_APPNAME}:${X11APPJAIL_PROFILE}.allow.<permission>` in the "[User Attributes](#user-attributes)" section.<br>|
| `secgroup-tables` | If `network.mode` is set to `virtualnet`, this attribute specifies a space-separated list of `pf(4)` tables to which the jail will be added using Security Group hooks.<br><br>If you are going to add additional labels related to Security Groups, do not include `security-group:1`, as this attribute already include it.<br><br>See also: https://github.com/DtxdF/AppJail/wiki/filter<br>|
| `system-fonts` | Read-only mounts the fonts system inside the jail, configure Fontconfig, and rebuild the font cache.|
| `virtualnet` | Specify the virtual network to be used when `network.mode` is set to `virtualnet`. If not specified, no virtual network is defined, so the default one is used.|

## OCI Configuration

```yaml
build:
  variants:
    - tag: 15.1
      containerfile: Containerfile
      aliases: ["latest"]
      default: true
      args:
        FREEBSD_RELEASE: "15.1"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
```
