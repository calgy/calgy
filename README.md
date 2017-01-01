# Calgy API Server

## Getting Started

### Using Docker

If you have docker installed, the easiest way to get up and running is to
use the docker-compose scripts provided with the app. You do not need to
install elixir or have to worry about any other dependencies.

Run the following only once:
```
docker-compose build
docker-compose start db
docker-compose run web mix ecto.setup
```

Run the following each time you want to start the server:
```
docker-compose up
```

You should now be able to access the server at http://localhost:4000/.

### Local Setup

You will need to install the following dependencies:

  * Elixir 1.3 or later
  * PostgreSQL 9.5 or later

To start the app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phoenix.server`

You should now be able to access the server at http://localhost:4000/.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).


## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
