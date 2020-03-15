FROM elixir:alpine as build

# install build dependencies
RUN apk add --update git build-base nodejs nodejs-npm yarn python

# prepare build dir
RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get
RUN mix deps.compile

# build assets
COPY assets assets
COPY priv priv
RUN cd assets \
  && npm install \
  && ./node_modules/webpack/bin/webpack.js --mode production \
  && npm run deploy
RUN mix phx.digest

# build project
COPY lib lib
RUN mix compile

# build release (uncomment COPY if rel/ exists)
# COPY rel rel
RUN mix release

# prepare release image
FROM alpine:3.9 AS app
RUN apk add --update bash openssl imagemagick

RUN mkdir /app
WORKDIR /app
ARG project_id
ENV PORT=8080 GCLOUD_PROJECT_ID=${project_id} REPLACE_OS_VARS=true
EXPOSE ${PORT}
COPY --from=build /app/_build/prod/rel/colorify ./
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app
CMD exec /app/bin/colorify start