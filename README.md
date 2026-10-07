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

### General usage

You can obtain the AppJail from the releases section of this repository. However, to go beyond a simple download and be able to update it conveniently from the console, the simplest complementary tool for our purposes is [sysutils/bin](https://freshports.org/sysutils/bin), a binary manager:

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

A system-wide installation requires only root access; the key is not necessary. However, it is strongly recommended to verify the binary before installation, making it necessary to install the key anyway.

```console
$ x11appjail verify ~/bin/badwolf.appjail
Signature Verified
$ doas ~/bin/badwolf.appjail --install
$ x11appjail run badwolf
```

An AppJail creates the jail only if it does not already exist or if the AppJail detects a valid change in its checksum (e.g.: after an update). This means that updates to the OCI image used by the AppJail are only checked at the creation time. If you need to update the OCI image, simply destroy the jail:

```console
$ x11appjail destroy-jail badwolf
```

Once you run the AppJail again, the OCI image is pulled again only if it is newer than the one on your system.
### User Permissions

By default, the jail lacks the necessary devices for sound, the webcam, hardware acceleration, etc., to work as expected. To achieve this, the system operator must grant the user certain permissions, and the user must allow the jail to be created with the specific permissions required for that session. This is implemented using attributes:

```console
$ UID=$(id -u)
$ doas x11appjail sys-attr users.${UID}.perms "enable_3d sound"
```

The previous command assumes that the shell process is running with unprivileged user rights and can use `doas(1)` to elevate privileges and execute the `sys-attr` command. This command will create the attribute based on the shell process's UID, with `enable_3d` and `sound` permissions. The user-side counterpart is as follows:

```console
$ x11appjail attr put badwolf:default.allow.enable_3d
$ x11appjail attr put badwolf:default.allow.sound
```

Although the user can create other attributes corresponding to actual permissions, such as `usb` or `webcam`, these are completely ignored if the system operator does not assign them.

If the jail has already been created, it must be destroyed for the changes to take effect.

```console
$ x11appjail destroy-jail badwolf
```

When you run this AppJail again, the devices will appear inside the jail, and sound and hardware acceleration will work as expected.

### Fonts

The OCI image containing all the necessary files does not install any fonts other than those essential for the application. However, this AppJail has the capability to mount system fonts in read-only mode, an operation that consumes no space.

```console
$ doas x11appjail sys-attr put mount.system-fonts
```

If the jail has already been created, it must be destroyed for the changes to take effect.

```console
$ x11appjail destroy-jail badwolf
```

Once the jail is recreated, the process may take some time to generate the font cache, depending on how many fonts you have on the system.

### Networking

Virtual networks are the recommended option for network connectivity. They offer granular control and allow for further isolation of the jail. However, this requires configuring and installing `appjail(1)` as specified in the "[Getting Started](https://appjail.readthedocs.io/en/latest/getting-started/)" guide.

```console
$ doas x11appjail sys-attr put network.mode virtualnet
```

If you are not concerned about the complete lack of network-level isolation, you can inherit the host's network stack.

```console
$ doas x11appjail sys-attr put network.mode inherit
```

If the jail has already been created, it must be destroyed for the changes to take effect.

```console
$ x11appjail destroy-jail badwolf
```

Once the jail has been recreated, you can check network connectivity by executing the following command:

```console
$ x11appjail run-cmd badwolf ping -c4 1.1.1.1
PING 1.1.1.1 (1.1.1.1): 56 data bytes
64 bytes from 1.1.1.1: icmp_seq=0 ttl=51 time=36.769 ms
64 bytes from 1.1.1.1: icmp_seq=1 ttl=51 time=36.617 ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=51 time=44.956 ms
64 bytes from 1.1.1.1: icmp_seq=3 ttl=51 time=36.360 ms

--- 1.1.1.1 ping statistics ---
4 packets transmitted, 4 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 36.360/38.675/44.956/3.629 ms
```

The above assumes that the jail is allowed to connect to `1.1.1.1` and send ICMP packets.


### Attributes
#### User Attributes

| Name | Description |
| --- | --- |
| `<appname>:<profile>.allow.enable_3d` | This permission will execute the application using VirtualGL and make hardware acceleration-related devices visible.|
| `<appname>:<profile>.jail.ephemeral` | Mark the jail as ephemeral. See `ephemeral` option in `appjail-quick(1)` for details.<br><br>Although the jail may be destroyed, its data is preserved in the user directory (see `${X11APPJAIL_USERDIR}` in `x11appjail-spec(5)`).<br>|
| `<appname>:<profile>.allow.sound` | This permission will make sound-related devices visible.|
| `<appname>:<profile>.allow.usb` | This permission will make usb-related devices visible.|
| `<appname>:<profile>.virtualgl.display` | If the user has the `enable_3d` permission, this specifies the display or EGL device to be used for 3D rendering. Since using EGL is the only logical choice for this project, the default value is `egl`. In multi-GPU environments, it is possible to specify a particular device.|
| `<appname>:<profile>.allow.webcam` | This permission will make webcam-related devices visible.|

#### System Attributes

| Name | Description |
| --- | --- |
| `<appname>:<profile>.labels` | A space-separated list of label names.|
| `network.mode` | Network mode. Default is `none`.<br><br>There are three modes:<br><br>1. `virtualnet`: This option is recommended, as it provides isolation and allows a more fine-grained control. It's necessary to install and configure AppJail on the host, as specified in the "[Getting Started](https://appjail.readthedocs.io/en/latest/getting-started/)" guide.<br>2. `inherit`: This mode does not provide network isolation. From a networking perspective, it is exactly the same as running the application on the host.<br>3. `none`: Completely disable the network stack.<br>|
| `oci.from` | Location of OCI image.|
| `oci.tag` | OCI image tag.|
| `<appname>:<profile>.labels.<label>` | The value of the label.|
| `<appname>:<profile>.oci.from` | Same as `oci.from`, but by application. It takes precedence when defined.|
| `<appname>:<profile>.oci.tag` | Same as `oci.tag`, but by application. It takes precedence when defined.|
| `users.<uid>.perms` | A space-separated list of "permissions" granted to a specific user.<br><br>The implemented "permissions" are presented below:<br><br>* `enable_3d`<br>* `webcam`<br>* `usb`<br>* `sound`<br><br>For a description of any of them, consult `${X11APPJAIL_APPNAME}:${X11APPJAIL_PROFILE}.allow.<permission>` in the "[User Attributes](#user-attributes)" section.<br>|
| `network.security-group.tables` | If `network.mode` is set to `virtualnet`, this attribute specifies a space-separated list of `pf(4)` tables to which the jail will be added using Security Group hooks.<br><br>If you are going to add additional labels related to Security Groups, do not include `security-group:1`, as this attribute already include it.<br><br>See also: https://github.com/DtxdF/AppJail/wiki/filter<br>|
| `mount.system-fonts` | Read-only mounts the fonts system inside the jail, configure Fontconfig, and rebuild the font cache.|
| `network.virtualnet` | Specify the virtual network to be used when `network.mode` is set to `virtualnet`. If not specified, no virtual network is defined, so the default one is used.|

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
