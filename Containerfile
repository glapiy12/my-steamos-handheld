FROM quay.io/fedora/fedora-kinoite:44

RUN curl -o /etc/yum.repos.d/rpmfusion-free.repo https://download1.rpmfusion.org/free/fedora/rpmfusion-free.repo && \
    curl -o /etc/yum.repos.d/rpmfusion-nonfree.repo https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree.repo && \
    curl -o /etc/yum.repos.d/bieszczaders-kernel-cachyos.repo https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos/repo/fedora-44/bieszczaders-kernel-cachyos-fedora-44.repo

RUN dnf install -y \
    steam \
    gamescope \
    gamescope-session \
    mangohud \
    gamemode \
    wine \
    winetricks \
    vulkan-tools \
    mesa-vulkan-drivers.i686 \
    mesa-libGL.i686 \
    steam-devices \
    ffmpeg-libs \
    gstreamer1-plugins-{bad-*,good-*,base} \
    gstreamer1-plugin-openh264 \
    lame \
    libavcodec-freeworld \
    vlc \
    hwdata \
    pciutils \
    usbutils \
    ryzenadj \
    power-profiles-daemon \
    kernel-cachyos \
    kernel-cachyos-headers \
    kernel-cachyos-modules \
    kernel-cachyos-modules-extra && \
    dnf clean all

COPY install-handygccs.sh /tmp/install-handygccs.sh
RUN bash /tmp/install-handygccs.sh

COPY setup-steamos-session.sh /tmp/setup-steamos-session.sh
RUN bash /tmp/setup-steamos-session.sh
