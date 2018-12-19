FROM bitwalker/alpine-elixir-phoenix:latest

# Set exposed ports
EXPOSE 4000 8080
ENV PORT=4000 MIX_ENV=dev

# Cache elixir deps
COPY mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

# Same with npm deps
WORKDIR /opt/app/assets
COPY assets/package.json .
RUN npm install

WORKDIR /opt/app
COPY . .