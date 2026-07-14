FROM ubuntu:20.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libegl1 openjdk-17-jdk-headless wget curl git lzip unzip \
        supervisor qemu-kvm iproute2 socat tzdata && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ARG NDK_TRANSLATION_REPO=Kaz205/vendor_google_proprietary_ndk_translation-prebuilt
ARG NDK_TRANSLATION_REF=chromeos_guybrush
RUN wget -q -O /opt/ndk-translation.tar.gz \
    "https://codeload.github.com/${NDK_TRANSLATION_REPO}/tar.gz/refs/heads/${NDK_TRANSLATION_REF}"

ARG ROOTAVD_REPO=newbit/rootAVD
ARG ROOTAVD_REF=master
RUN wget -q -O /opt/rootavd.tar.gz \
    "https://gitlab.com/${ROOTAVD_REPO}/-/archive/${ROOTAVD_REF}/rootAVD-${ROOTAVD_REF}.tar.gz"

RUN mkdir -p /opt/android-sdk/cmdline-tools && \
    cd /opt/android-sdk/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip -O cmdline-tools.zip && \
    unzip cmdline-tools.zip -d latest && \
    rm cmdline-tools.zip && \
    mv latest/cmdline-tools/* latest/ || true && \
    rm -rf latest/cmdline-tools || true

ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_AVD_HOME=/data
ENV ADB_DIR=$ANDROID_HOME/platform-tools
ENV PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ADB_DIR:$PATH

RUN mkdir /root/.android/ && touch /root/.android/repositories.cfg && mkdir /data && mkdir /extras

RUN yes | sdkmanager --sdk_root=$ANDROID_HOME "emulator" "platform-tools" "platforms;android-30" "system-images;android-30;default;x86_64"
RUN rm -f /opt/android-sdk/emulator/crashpad_handler

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY first-boot.sh /root/first-boot.sh
RUN chmod +x /root/first-boot.sh
COPY start-emulator.sh /root/start-emulator.sh
RUN chmod +x /root/start-emulator.sh

EXPOSE 5554 5555

HEALTHCHECK --interval=10s --timeout=10s --retries=600 \
  CMD adb devices | grep emulator-5554 && test -f /data/.first-boot-done || exit 1

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Build: docker build -t android-emulator-cloud-run .
# Run:   docker run -d --name android-emulator-cloud-run --device /dev/kvm --privileged -p 5555:5555 android-emulator-cloud-run
