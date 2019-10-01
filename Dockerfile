FROM bitwalker/alpine-elixir-phoenix:latest

# Set exposed ports
EXPOSE 4000 8080
ENV PORT=4000

# Cache elixir deps
COPY mix.exs mix.lock ./
RUN mix deps.get
RUN mix deps.compile

# Same with npm deps
WORKDIR /opt/app/assets
COPY assets/package.json .
RUN npm install
RUN mkdir -p priv/static
RUN npm run deploy

WORKDIR /opt/app
COPY . .