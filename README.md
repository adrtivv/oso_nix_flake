# About

Nix flake for the [oso](https://www.osohq.com/docs) packages.

# Flake packages

Currently the following oso packages are provided as flake package outputs:

1. [Oso cloud cli](https://www.osohq.com/docs/app-integration/client-apis/cli)
2. [Oso dev server](https://www.osohq.com/docs/development/oso-dev-server)

# Warning

The oso cloud cli binary is downloaded from the `d3i4cc4dqewpo9.cloudfront.net` domain which is listed in [this](https://ui.osohq.com/install.sh) installation script linked on their documentation site [here](https://www.osohq.com/docs/app-integration/client-apis/cli#install-the-oso-cloud-cli-package). As you can see, the url is kind of weird and dynamic looking and could be changed at some point in the future for all I know. If that happens and this script isn't updated accordingly an attacker could use this domain to supply a malicious binary to the users of this flake.

Now the sha256 hashes matched in the flake do prevent that hypothetical scenario but this warning is being listed here just in case.
