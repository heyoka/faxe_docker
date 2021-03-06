### Build stage 0
FROM erlang:22.3 as erlang

# Set working directory
RUN mkdir -p /buildroot/rebar3/bin
WORKDIR /buildroot

# Copy faxe application
COPY ./ faxe

WORKDIR faxe

# need git
RUN apt-get install git

# And build the release
RUN rebar3 as prod release

### Build stage 2
FROM erlang

# Install some libs
RUN apt-get install openssl

ENV RELX_REPLACE_OS_VARS true

# Install the released application
COPY --from=erlang /buildroot/faxe/_build/prod/rel/faxe /faxe
# cleanup
RUN rm -rf /buildroot

# USER ubuntu

# Expose relevant ports
## http api
EXPOSE 8081
EXPOSE 1883
EXPOSE 8883

ENTRYPOINT ["/faxe/bin/faxe"]
CMD ["foreground"]