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

WORKDIR /opt/app
COPY . .