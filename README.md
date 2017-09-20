# Calgy API Server

**TOO EARY TO BE USEFUL, CHECK BACK LATER.**

## Overview

Web server providing an API for managing calendars.

The most recent copy of the Calgy API specification can be found at
[apps/calgy_api/doc/calgy-api-spec.html](https://rawgit.com/calgy/calgy/master/apps/calgy_api/doc/calgy-api-spec.html).


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
   ```bash
   docker-compose run --rm web mix cmd --app calgy mix ecto.setup
   docker-compose stop
   ```

#### Starting the Server

Run the following each time you want to start the server:
```bash
docker-compose up
```

You should now be able to access the server at http://localhost:4000/.

#### Running the Test Suite

If you are already running the web container, it's a little bit faster to
run the test suite using the same container instance by using `exec`:
```bash
docker-compose exec web mix test
```

Otherwise, you can start a new web container to run the test suite:
```bash
docker-compose run web mix test
```

#### Database Console

If you need to access a database console:
```bash
docker-compose exec db psql calgy_dev
```

### Manual Setup

You will need to install the following dependencies:

  * Elixir 1.4 or later
  * PostgreSQL 9.5 or later

To start the app:

  * Install dependencies with `mix deps.get` and then `mix deps.compile`
  * Create and migrate your database with `mix cmd --app calgy mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

You should now be able to access the server at http://localhost:4000/.


## API Specification

The most recent copy of the Calgy API specification can be found at
[apps/calgy_api/doc/calgy-api-spec.html](https://rawgit.com/calgy/calgy/master/apps/calgy_api/doc/calgy-api-spec.html).

### Updating / Regenerating the Specification

When making changes to the calgy-api-spec.raml file, a new copy of the HTML
version of the documentation should also be generated and committed; this
ensures the latest specification is available for browsing without having to
install anything.

Make sure you have [raml2html](https://github.com/raml2html/raml2html) installed:

```bash
npm install -g raml2html
```

To generate HTML documentation of the API specification:

```bash
cd apps/calgy_api/
raml2html --input doc/calgy-api-spec.raml --output doc/calgy-api-spec.html
```
