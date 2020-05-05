FROM archlinux:latest
# as base
MAINTAINER thestr4ng3r

RUN pacman --noconfirm -Syu base-devel git sudo

#RUN sudo pacman --noconfirm -S x2goserver meson python-mako llvm
#RUN cd /root && curl https://mesa.freedesktop.org/archive/mesa-20.0.5.tar.xz -o mesa.tar.gz && \
#	tar -xf mesa.tar.gz && cd mesa-20.0.5 && \
#	mkdir build && cd build && \
#	meson -Dllvm=true -Dglx=gallium-xlib -Dgallium-drivers=swrast -Dplatforms=x11 -Ddri3=false -Ddri-drivers="" -Dvulkan-drivers="" -Dbuildtype=release -Doptimization=3 --prefix=/usr/local/mesa-libgl-xlib .. && \
#	ninja && ninja install

RUN pacman --noconfirm -S xorg-server supervisor openssh xfce4 noto-fonts tilix vim obs-studio vlc

# some dev stuff
RUN pacman --noconfirm -S cmake mesa-demos

#RUN x2godbadmin --createdb

RUN pacman --noconfirm -S virtualgl

# most permissive config
RUN vglserver_config -config +s +f +t

COPY bin /usr/local/bin
COPY etc /etc

RUN mkdir /run/dbus && \
	echo "/usr/bin/dbus-launch /usr/bin/startxfce4" > /etc/X11/xinit/xinitrc

# tigervnc to test
RUN pacman --noconfirm -S tigervnc
RUN pacman --noconfirm -S xf86-video-intel

VOLUME ["/etc/ssh"]
EXPOSE 22
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["supervisord"]
