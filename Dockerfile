FROM elixir:1.5

ENV PORT 4000

WORKDIR /app
COPY . /app

# It should be possible to make the phoenix server run as a regular user,
# but this only works we don't mount another volume over /app.  Mounting
# another volume happens as root, and the permissions of the mounted volume
# bleed through; the phoenix user probably doesn't share the same uid/gid
# as the user's filesystem outside the container, so it cannot write files.
#RUN groupadd -r phoenix && useradd -r -m -g phoenix phoenix
#RUN chown -R phoenix:phoenix /app
#USER phoenix

RUN mix local.hex --force \
  && mix local.rebar --force \
  && mix deps.get \
  && mix deps.compile \
  && mix compile \

VOLUME /app
EXPOSE ${PORT}

CMD ["mix", "phx.server"]
