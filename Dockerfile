FROM archlinux:latest
# as base
MAINTAINER thestr4ng3r

RUN pacman --noconfirm -Syu base-devel git sudo

# dependencies for xrdp, xorgxrdp and pulseaudio
RUN pacman --noconfirm -S tigervnc libxrandr lame opus fuse nasm \
	xorg-server-devel \
	pulseaudio

COPY bin/install-aur /usr/bin/install-aur

# prepare for install-aur
RUN useradd -m build && \
	passwd -d build && \
	printf 'build ALL=(ALL) ALL\n' | tee -a /etc/sudoers

RUN install-aur xrdp
RUN sudo -u build gpg --recv-keys 9F72CDBC01BF10EB && install-aur xorgxrdp

# RUN install-aur pulseaudio-module-xrdp # Doesn't work
COPY pulseaudio-module-xrdp /home/build/pulseaudio-module-xrdp
RUN chown -R build /home/build/pulseaudio-module-xrdp && sudo -u build bash -c "cd /home/build/pulseaudio-module-xrdp && makepkg --noconfirm -si"

RUN pacman --noconfirm -S xorg-server supervisor openssh xfce4 noto-fonts tilix vim obs-studio vlc

COPY bin /usr/bin
COPY etc /etc

RUN mkdir /run/dbus && \
	echo "allowed_users=anybody" > /etc/X11/Xwrapper.config && \
	echo "/usr/bin/dbus-launch /usr/bin/startxfce4" > /etc/X11/xinit/xinitrc

VOLUME ["/etc/ssh"]
#,"/home"]
EXPOSE 3389 22 9001
ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]
CMD ["supervisord"]
