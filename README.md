# bazzite-dx-lotsaspaghetti &nbsp; [![bluebuild build badge](https://github.com/lotsospaghetti/bazzite-dx-lotsaspaghetti/actions/workflows/build.yml/badge.svg)](https://github.com/lotsospaghetti/bazzite-dx-lotsaspaghetti/actions/workflows/build.yml)

A personal and experimental ~~`bazzite-dx:stable`~~ [Bazzirco](https://github.com/bazzirco/bazzirco)-based image that I use to install new system-level software and setup some preconfigured preferences such as my [dotfiles](https://codeberg.org/lotsaspaghetti/dotfiles). This goes without saying, but this image has **zero support** and I do not recommend using it directly. This repo uses [BlueBuild](https://blue-build.org/) and below is a list of major changes I try to keep updated, so anything others might be interested in should be easy to implement in other custom images.

## Modifications

- [Zed](https://zed.dev/) replaces VSCode as the system's primary code editor
- ~~[Niri](https://github.com/niri-wm/niri) is available as an additional desktop session~~ *now based on Bazzirco which has Niri by default*
- Nix support: Provides a `/nix` directory and a [justfile](files/justfiles/determinate-nix.just) for installing and managing [Determinate Nix](https://github.com/DeterminateSystems/nix-installer)
- Experimental [Winboat](https://winboat.app) support

## Installation

> [!WARNING]  
> [This is an experimental feature](https://www.fedoraproject.org/wiki/Changes/OstreeNativeContainerStable), try at your own discretion.

To rebase an existing atomic Fedora installation to the latest build:

- First rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/lotsospaghetti/bazzite-dx-lotsaspaghetti:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, like so:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/lotsospaghetti/bazzite-dx-lotsaspaghetti:latest
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```

The `latest` tag will automatically point to the latest build. That build will still always use the Fedora version specified in `recipe.yml`, so you won't get accidentally updated to the next major version.

## ISO

If build on Fedora Atomic, you can generate an offline ISO with the instructions available [here](https://blue-build.org/how-to/generate-iso/#_top). These ISOs cannot unfortunately be distributed on GitHub for free due to large sizes, so for public projects something else has to be used for hosting.

## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/lotsospaghetti/bazzite-dx-lotsaspaghetti
```
