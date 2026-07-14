# Android Emulator Cloud Runner

<img align="right" src="/doc/dockerify-android-web-preview.png" />

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker Pulls](https://img.shields.io/docker/pulls/shmayro/dockerify-android)](https://hub.docker.com/r/shmayro/dockerify-android)

**Android Emulator Cloud Runner** is a containerized Android emulator with native ARM translation support, Google GAPPS, Magisk root, and a built-in web interface. Designed for cloud-native CI/CD pipelines, it enables scalable Android testing and development in any Docker or Kubernetes environment.

### 🔥 **Key Feature: Web Interface Access** 🌐

Access and control the Android emulator directly in your browser with the integrated scrcpy-web interface. No extra software required — just open your browser and start interacting with the virtual device.

> **Benefits:**
> - Zero client-side installation
> - Access from any device with a web browser
> - Full touch + keyboard support
> - Perfect for remote teams and cloud infrastructure

<br clear="right"/>

## 📜 **Table of Contents**

- [Features](#-features)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Usage](#-usage)
  - [Web Interface](#web-interface)
  - [ADB Access](#adb-access)
  - [scrcpy Mirror](#scrcpy-mirror)
  - [Environment Variables](#environment-variables)
- [First Boot Process](#-first-boot-process)
- [Container Logs](#-container-logs)
- [Troubleshooting](#-troubleshooting)
- [License](#-license)

## 🔧 **Features**

- **🌐 Web Interface:** Browser-based emulator control via scrcpy-web
- **🔄 ARM Translation:** Run ARM/ARM64 native apps on x86_64 using ndk_translation
- **Root + Magisk:** Preinstalled root access with Magisk manager
- **PICO GAPPS:** Essential Google services included
- **Seamless ADB:** Connect via ADB from host or network
- **scrcpy Mirror:** Native desktop mirroring support
- **Multi-Architecture:** Runs on both x86_64 and arm64 hosts
- **Docker/K8s Ready:** Built for cloud infrastructure and CI/CD pipelines
- **Supervisor Managed:** Reliable process management inside container

## 🛠️ **Prerequisites**

- **Docker** installed on your system ([Installation Guide](https://docs.docker.com/get-docker/))
- **Docker Compose** for orchestration ([Installation Guide](https://docs.docker.com/compose/install/))
- **KVM Support** for hardware acceleration:
  ```bash
  egrep -c '(vmx|svm)' /proc/cpuinfo
  ```

## 🚀 **Quick Start**

```bash
git clone https://github.com/luoshixin93-sudo/android-emulator-cloud-run.git
cd android-emulator-cloud-run
docker compose up -d
```

Access the web interface at `http://localhost:8000`

> **First boot takes 10-15 minutes.** Monitor progress with `docker logs -f android-emulator-cloud-run`

## 📡 **Usage**

### Web Interface

1. Open browser → `http://localhost:8000`
2. Device appears as "android-emulator-cloud-run:5555"
3. Choose streaming option: H264 (recommended), Tiny H264, or Broadway.js

### ADB Access

```bash
adb connect localhost:5555
adb devices
# localhost:5555 device
```

### scrcpy Mirror

```bash
scrcpy -s localhost:5555
```

> Ensure `scrcpy` is installed on your host ([Installation Guide](https://github.com/Genymobile/scrcpy#installation))

## ⚙️ **Environment Variables**

| Variable | Description | Default |
| --- | --- | --- |
| `DNS` | Private DNS server | `one.one.one.one` |
| `RAM_SIZE` | RAM in MB | `4096` |
| `SCREEN_RESOLUTION` | Screen `WIDTHxHEIGHT` | device default |
| `SCREEN_DENSITY` | Screen DPI | device default |
| `ROOT_SETUP` | Enable Magisk root (`1`=on) | `0` |
| `GAPPS_SETUP` | Install PICO GAPPS (`1`=on) | `0` |
| `ARM_TRANSLATION` | Enable ARM-on-x86 (`1`=on) | `1` |

## 🔄 **First Boot Process**

The first boot performs:
1. AVD creation (Android 30 / Android 11)
2. GAPPS installation (if `GAPPS_SETUP=1`)
3. Magisk rooting (if `ROOT_SETUP=1`)
4. ARM translation layer (if `ARM_TRANSLATION=1`)
5. Extras copied to `/sdcard/Download`

First boot complete when logs show:
```
Broadcast completed: result=0
Success !!
2025-04-22 13:45:18,724 INFO exited: first-boot (exit status 0; expected)
```

## 📋 **Container Logs**

```bash
docker logs -f android-emulator-cloud-run
```

## 🐞 **Troubleshooting**

- **ADB Connection Refused:** Ensure port `5555` is open; check `docker logs`
- **First Boot Slow:** Normal; downloads and configures system on first run
- **ARM Apps Won't Install:** Set `ARM_TRANSLATION=1` and restart container
- **KVM Not Accessible:** Check `/dev/kvm` permissions and host CPU virtualization

---

Made with ❤️ for cloud phone automation → [qtphone.com](https://www.qtphone.com/)
