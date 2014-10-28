FROM progrium/cedarish:cedar14
MAINTAINER Jeff Lindsay <progrium@gmail.com>
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

ADD ./stack/configs/etc-profile /etc/profile
ADD ./stack/ /build/stack
ADD ./builder/ /build

RUN /build/stack/add_ons.sh
RUN xargs -L 1 /build/install-buildpack /tmp/buildpacks < /build/config/buildpacks.txt
