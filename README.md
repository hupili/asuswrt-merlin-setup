# asuswrt-merlin-setup

Notes, configs and commands for setting up an asuswrt-merlin router for entire family to access Internet scientifically

**Last Update:** 20181224

## Tested Model

- Asus RT-AC-1900P

## Notes 

### Prerequisite

- An USB (for entware) -- entware asks for a partiition before setup.
- A working SS Server. (traffic will be routed via this node)

### Major steps and explanation

- Find "RT-AC68U" firmware from [official download site](https://asuswrt.lostrealm.ca/download), because [Model RT-AC1900P use the RT-AC68U firmware](https://github.com/RMerl/asuswrt-merlin/wiki/Supported-Devices).
- Setup basic options of the router and enable JFFS:
  - Tick "Enable JFFS"
  - Tick "Format JFFS on next boot" -- This gives a clean start next time.
  - Tick "Allow custom scripts from JFFS" -- `services-start` script in [jffs/scripts/](jffs/scripts/) will be executed upon boot.

  [JFFS](https://github.com/RMerl/asuswrt-merlin/wiki/Jffs) is a writable space on the router's flash drive that "survives" reboot. Many other mount points under `/` are in RAM and will be erased upon reboot. However, it does not necessarily survive flashing (firmware rewrite). You may need to back it up before flashing.
- Restart router.
- Plugin USB
- Run `entware-setup.sh` script to setup entware. After this, you can use `opkg` pakcage manager to install other plugins. Tip: choose disk "1" (It is the only option if you only have one USB plugged) during the setup.
- Restart router.
- Install essential packages vi `opkg install`. See appendix 1.
- Rewrite files from this repo to the router disk with corresponding relative paths. Directories include `jffs`, `mnt` and `opt`.
- Fill in the `shadowsocks.json` file with your own SS server information. You only need to modify the values with placeholder `INPUT-xxx`.
- Restart router.

Note: You may need to restart router upon key steps above.

### Topology

```
raw TCP
-- (iptables) -->
REDSOCK
-- (wrap SOCKS5 layer) -->
ShadowSocks (local) 
-- (The Internet) -->
ShadowSocks (server) 
-- (unwrap SOCKS5 layer) -->
raw TCP
--> destination
```

### Features

- Tunnel TCP traffic of all wired/ wireless users to this router via ShadowSocks.
- Use `DNSCrypt` to ensure correct domain name resolution.
- Periodically restart (`cru`) the services. (SS is easy to die upon malformed network packets/ memory constraint)

### Appendix 1: OPKG Packages

```
shadowsocks-libev-ss-local
redsocks
dnscrypt-proxy
dnsmasq-full
fake-hwclock
```

### Appendix 2: RedSocks and iptables

ShadowSocks establishes a local socks5 server. In order to use Socks5, the client needs to be Socks-aware, i.e. conducts Socks5 handshake and then send TCP traffice. In essence, Socks5 is a session layer protocol, but your LAN users may not be aware of that. The LAN users send usual TCP/ IP packets to the router. So we need to instruct the router to wrap those packets into Socks5 protocol and then send that to the `1080` (SS local port). This is done as follows:

- Use `iptables` to route non-local TCP traffic to port `12345`.
- RedSocks listen raw traffic on `12345` and wrap whatever seen into Socks5 protocol and then act as Socks5 client to communicate with ShadowSocks on `1080`. From ShadowSocks perspective, RedSocks is a Socks5 client. From LAN users perspective, RedSocks is the (Internet) server they are talking to.

## Alternative firmware

The koolshare version ships with a "Software Center" that may significantly simplify the followup configuration procedures.

- asuswrt-koolshare
- asuswrt-merlin-koolshare

Those firmware can be downloaded from [this post](http://koolshare.cn/thread-127878-1-1.html) and the instructions can be found from [this post](http://koolshare.cn/thread-145914-1-1.html).

**Precuation**: In my recent test (20181224), after installing `asus-merlin-AC68U version 384.8_2`, it fails to flash the koolshare's modified firmware of `384.8_2`. That is why I turned to manual mode and created this repo.
