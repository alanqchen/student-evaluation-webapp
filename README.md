# Evaluate.me

Website evaluation tool.

## Local Setup

To help simplify the development setup and workflow, we'll use Docker and Docker Compose.

For Ubuntu x86-64 Systems:

1. [Follow steps 1 and 2 to install Docker](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04)
   - **After step 2, also run `newgrp docker`, and then run `docker run hello-world` to test that it works**
2. [Follow step 1 to install Docker Compose](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04)
3. Ensure `docker compose version` works

Then to setup the project:

1. Run `cp .env.sample .env` and change the password in `.env`
2. Run `docker compose build`
3. Run `docker compose run --rm web bin/rails db:setup`
4. Run `docker compose run --rm web bin/rails tailwindcss:build`

## Development

To run locally, use `docker compose up`. Add the `-d` flag to detach from docker-compse after starting the containers (though for development its recommended to open a second terminal tab/window instead).

Once the bundles are installed and the rails server is ready, you should see something similar to

```bash
evaluate_me-web-1  | => Booting Puma
evaluate_me-web-1  | => Rails 7.0.2.3 application starting in development 
evaluate_me-web-1  | => Run `bin/rails server --help` for more startup options
evaluate_me-web-1  | Puma starting in single mode...
evaluate_me-web-1  | * Puma version: 5.6.4 (ruby 3.0.3-p157) ("Birdie's Version")
evaluate_me-web-1  | *  Min threads: 5
evaluate_me-web-1  | *  Max threads: 5
evaluate_me-web-1  | *  Environment: development
evaluate_me-web-1  | *          PID: 1
evaluate_me-web-1  | * Listening on http://0.0.0.0:3000
evaluate_me-web-1  | Use Ctrl-C to stop
```

Then in another terminal tab/window, run `docker compose exec web bin/rails tailwindcss:watch`, this will rebuild the css automatically as changes are made.

Then you can view `http://0.0.0.0:3000` in a browser.

### Creating Tests

Since we're using RSpec for tests, all tests should be under the `spec` directory, **not** the `test` directory.

### Running Rails Commands

All rails commands work the same as not using docker at all, but you must prepend one of the docker commands shown below to run them:

When the app is already running with `docker compose up`, attach to the container (it can take a couple seconds to run):

```bash
docker compose exec web bin/rails <command>
```

If no container is running yet:

```bash
docker compose run --rm web bin/rails <command>
```

Generally, you'll use `run --rm` to run the tests and rubocop locally, and `exec` in most other cases.

#### Example Running Rails Console

To access the rails console when the app is running, use to following:

```bash
docker compose exec web bin/rails console
```

#### Example Resetting Database

The following will remove all data from the database and rerun the migrations:

```bash
docker compose exec web bin/rails db:drop db:create db:migrate db:seed
```

#### Example Adding NPM Package

Rails 7 allows us to import packages using `importmaps-rails`:

```bash
docker compose exec web bin/importmap pin <package name>
```

And use `unpin` to remove a package.

### Running Tests

Use RSpec to run all tests:

```bash
docker compose run --rm web bin/rspec
```

### Running Rubocop

Use the `--auto-correct` flag to fix automatically fix supported offenses.

```bash
docker compose run --rm web bin/bundle exec rubocop --parallel --auto-correct
```

### Production

1. `heroku container:push web --recursive`
2. `heroku container:release web`

If it is the first time the database is started, set it up using

1. `heroku run rake db:migrate db:seed`

Note for Heroku, you also need to set `SECRET_KEY_BASE`.

1. Generate a secrete key using `rake secret`
2. Run `heroku config:set --app=<app name> SECRET_KEY_BASE='generate key'`

## References

- [Docker Configuration](https://evilmartians.com/chronicles/ruby-on-whales-docker-for-ruby-rails-development)
- [General Configuration](https://github.com/ryanwi/rails7-on-docker)
- [FactoryBot](https://semaphoreci.com/community/tutorials/working-effectively-with-data-factories-using-factorygirl)
- [CSS Wave](https://www.csscodelab.com/water-effect-simple-css-wave-animation/)
