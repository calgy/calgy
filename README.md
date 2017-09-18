# Calgy API Server

**TOO EARY TO BE USEFUL, CHECK BACK LATER.**

## Overview

Web server providing an API for managing calendars. Specification of the API
can be found at <https://github.com/calgy/calgy-api-spec>.


## Local Development

### Using Docker

If you have docker installed, the easiest way to get up and running is to
use the docker-compose config provided with the app. You do not need to
install elixir or have to worry about any other dependencies.

#### Initial Setup

1. Build the initial docker image for the application:
```bash
docker-compose build

```

2. Create the PostgreSQL database and run migrations. It takes a little
while for the database image to initialize on the first run, so you may see
a repeated message about it being unavailable for up to a minute or two.

Run the following only once:
```
docker-compose run --rm web mix cmd --app calgy mix ecto.setup
docker-compose stop
```

#### Starting the Server

Run the following each time you want to start the server:
```
docker-compose up
```

You should now be able to access the server at http://localhost:4000/.

#### Running the Test Suite

If you are already running the web container, it's a little bit faster to
run the test suite using the same container instance by using `exec`:
```
docker-compose exec web mix test
```

Otherwise, you can start a new web container to run the test suite:
```
docker-compose run web mix test
```

#### Database Console

If you need to access a database console:
```
docker-compose exec db psql calgy_dev
```

### Manual Setup

You will need to install the following dependencies:

  * Elixir 1.4 or later
  * PostgreSQL 9.5 or later

To start the app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phoenix.server`

You should now be able to access the server at http://localhost:4000/.
