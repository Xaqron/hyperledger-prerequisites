# Hyperledger Prerequisites

Bash script for [hyperledger prerequisites](http://hyperledger-fabric.readthedocs.io/en/latest/prereqs.html) installation on a debian machine (tested on Ubuntu server 18.04) for running the [examples](http://hyperledger-fabric.readthedocs.io/en/latest/build_network.html).

## Usage

Run the bash script:

```bash
curl -o- https://raw.githubusercontent.com/Xaqron/hyperledger-prerequisites/master/hlp.sh | source
```

After reboot you can run [hyperledger fabric](https://github.com/hyperledger/fabric) bootstrap script:

```bash
curl -sSL https://raw.githubusercontent.com/hyperledger/fabric/master/scripts/bootstrap.sh | bash
```
