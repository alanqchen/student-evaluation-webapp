# Evaluate.me

Website evaluation tool.

## Local Setup

To help simplify the development setup and workflow, we'll use Docker and Docker Compose.

For Ubuntu:

1. [Follow steps 1 and 2 to install Docker](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04)
2. [Follow step 1 to install Docker Compose](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04)
3. Ensure `docker compose version` works

Then to setup the project:

1. Run `cp .env.example .env` and change the password in `.env`
2. Run `docker compose build`
3. Run `docker compose run --rm web bin/rails db:setup`

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

Then you can view `http://0.0.0.0:3000` in a browser.

### Frontend Development

If making changes to the frontend, you'll also need to run Tailwind in watch mode so that changes are reflected in the generated CSS output:

```bash
docker compose exec web bin/rails tailwindcss:watch
```

### Running Rails Commands

When the app is already running with `docker compose up`, attach to the container (it can take a couple seconds to run):

```bash
docker compose exec web bin/rails <command>
```

If no container is running yet:

```bash
docker compose run --rm web bin/rails <command>
```

#### Example Running Rails Console

To access the rails console when the app is running, use to following:

```bash
docker compose exec web bin/rails console
```

#### Example Updating Gemfile

If you change the Gemfile, you can then install the new dependencies using

```bash
docker compose run --rm web bin/bundle install
```

### Running Tests

Use RSpec to run all tests:

```bash
docker compose run --rm web bin/rspec
```

### Running Rubocop

Use the `--auto-correct` flag to fix automatically fix supported offenses.

```bash
docker compose exec web bin/bundle exec rubocop --parallel --auto-correct
```

### Production

1. `heroku container:push web --recursive`
2. `heroku container:release web`

Note for Heroku, you also need to set `SECRET_KEY_BASE`.

1. Generate a secrete key using `rake secret`
2. Run `heroku config:set --app=<app name> SECRET_KEY_BASE='generate key'`

## References

- [Docker Configuration](https://evilmartians.com/chronicles/ruby-on-whales-docker-for-ruby-rails-development)
