FROM erlang:20.3.2-alpine

ARG ocs_ver=v3.0.7
# Download dependency packages
RUN apk add --update --no-cache autoconf make gcc openssl-dev git automake libtool g++ nodejs nodejs-npm vim

# Install Rebar3
RUN mkdir -p /buildroot/rebar3/bin
ADD https://s3.amazonaws.com/rebar3/rebar3 /buildroot/rebar3/bin/rebar3
RUN chmod a+x /buildroot/rebar3/bin/rebar3

# Setup Environment
ENV PATH=/buildroot/rebar3/bin:$PATH

# Reset working directory
#WORKDIR /buildroot

WORKDIR /opt/

RUN git clone https://github.com/sigscale/ocs.git
WORKDIR /opt/ocs

#RUN git fetch --tags
#RUN git checkout tags/$ocs_ver -b $ocs_ver

ADD sys.config .
ADD build.sh .

RUN ./build.sh

#CMD erl -pa ebin ../lib/mochiweb-2.17.0/ebin ../lib/radius-1.4.4/ebin -sname ocs -config sys —boot ocs

WORKDIR /opt/ocs/.build/otp-20/ocs
ADD entrypoint.sh .
ENTRYPOINT ./entrypoint.sh
#CMD /bin/bash
