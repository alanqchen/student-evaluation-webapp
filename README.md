# Evaluate.me

Website evaluation tool.

## Local Setup

If there's any errors that show up at any step, do not continue and send a message in Discord.

1. Ensure you have the following:
   - Ruby 3.0.3
     - `rbenv install 3.0.3 && rbenv global 3.0.3`
   - Rails 7.0.2
     - Update rails using `gem install rails --no-document`
   - Postgres
     - MacOS:
       1. `brew install postgresql`
       2. Start Postgres using `brew services start postgresql`
     - Ubuntu:
       1. `sudo apt update && sudo apt upgrade`
       2. `sudo apt install postgresql postgresql-contrib libpq-dev`
       3. Check that installation was successful using `postgres -V`
       4. `sudo -u postgres createuser -d <ubuntu user name> -P`
            - Enter a password when prompted, and make sure to record it some place
            - This creates a PostgreSQL user role with permission to create databases
       5. Make a new copy of `.env.sample` called `.env`
       6. Edit the values of `DATABASE_USERNAME` and `DATABASE_PASSWORD` in `.env` to match the credientials of your PostgreSQL user

2. Then run `bundle install` in the project directory - if there's any errors that show up, send a message in Discord.
3. Next run `./bin/rails db:create` to create the local database

## Running

### Development

Run `./bin/dev`

### Production

TBD
