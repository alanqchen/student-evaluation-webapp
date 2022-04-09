# Evaluate.me

Website evaluation tool.

## Local Setup

To help simplify the development setup and workflow, we'll use Docker and Docker Compose.

For Ubuntu:
1. [Follow steps 1 and 2 to install Docker](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04)
2. [Follow step 1 to install Docker Compose](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04)
3. Ensure `docker-compose version` works

Then to setup the project:
1. Run `cp .env.example .env` and change the password in `.env`
2. Run `docker compose build`
3. Run `docker compose run --rm web bin/rails db:setup`

## Running

### Development

To run locally, use `docker compose up`. Add the `-d` flag to detach from docker-compse after starting the containers.

### Production

TBD
