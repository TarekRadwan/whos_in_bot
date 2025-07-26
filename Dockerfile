# Stage 1: Build release on Linux
FROM elixir:1.15-alpine as build

# Install build tools
RUN apk add --no-cache build-base git postgresql-client

WORKDIR /app

# Copy mix files and get deps
COPY mix.exs mix.lock ./
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get

# Copy app source and compile
COPY . .
ENV MIX_ENV=prod
RUN mix deps.compile && mix release

# Stage 2: Run the release
FROM alpine:3.18

RUN apk add --no-cache libstdc++ openssl ncurses postgresql-client

WORKDIR /app

# ✅ Copy release
COPY --from=build /app/_build/prod/rel/whos_in_bot ./
# ✅ Copy priv directory with migrations
COPY --from=build /app/priv ./priv

ENV LANG en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV MIX_ENV=prod

EXPOSE 5000

ENTRYPOINT ["bin/whos_in_bot"]
CMD ["start_iex"]
