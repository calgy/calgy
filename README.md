# Calgy API Server

**TOO EARY TO BE USEFUL, CHECK BACK LATER.**

## Overview

Web server providing an API for managing calendars.

The most recent copy of the Calgy API specification can be [viewed online using ReDoc](https://rebilly.github.io/ReDoc/?url=https://raw.githubusercontent.com/calgy/calgy/master/apps/calgy_api/doc/calgy-api-spec.yml).

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

Calgy uses OpenAPI 3.0 to document its web API. The specification is kept in
the calgy_api app under [apps/calgy_api/doc/calgy-api-spec.yml]([apps/calgy_api/doc/calgy-api-spec.yml).

### Viewing Locally / Making Changes

#### ReDoc (via docker-compose)

If you have already started the calgy server using `docker-compose up`, a
copy of the documentation should be available at http://localhost:4001/. The
documentation viewer runs a copy of [ReDoc](https://github.com/Rebilly/ReDoc)
in a separate docker container that listens for requests on port 4001. If you
want to spin up the documentation viewer separate from the application, you
can run the following:

```bash
docker-compose up openapi
```

#### Alternative Viewers / Editors

If you do not wish to modify the specification directly, some IDEs have
plugins to view or modify OpenAPI 3.0 compatible specifications, There is
also a [list of projects related to OpenAPI 3.0](https://github.com/Mermade/awesome-openapi3).

#### OpenAPI Resources

There's not a lot of great material for teaching or best practices regarding
the latest 3.0 version of the specification, so you will probably have to rely
on reading through the dense specification. Before 3.0, the specification used
to go by the name "swagger" and looked substantially different than it does
now. The [Swagger site](https://swagger.io/docs/specification/about) describes
the latest 3.0 specification a little bit better than the official spec (use
the side nav), but many parts of the site also refer to version 2.0 which is
not compatible. Many of the tools also do not yet support 3.0, or only
partially support it.

* [OpenAPI 3.0 Specification](https://github.com/OAI/OpenAPI-Specification/blob/3.0.0/versions/3.0.0.md)
* [JSON Schema Core Specification](http://json-schema.org/latest/json-schema-core.html)
* [JSON Schema Validation Specification](http://json-schema.org/latest/json-schema-validation.html)
* [Official OpenAPI Initiative Site](https://www.openapis.org/)
* ["What is OpenAPI?" on the Swagger site](https://swagger.io/docs/specification/about/)
* [awesome-openapi3 on GitHub](https://github.com/Mermade/awesome-openapi3)
* [Projects tagged with openapi3 on GitHub](https://github.com/search?q=topic%3Aopenapi3)
