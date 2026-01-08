# Unofficial Cards Against Humanity, Online

An unofficial online version of the Cards Against Humanity game. Pairs well with friends, booze and video chat.

[Click here to play](https://www.cardiganshumility.online).

Put together by [Kevin Bongart](http://kevinbongart.net) so he could play his beloved game with friends during tough times. Not affiliated with the official [Cards Against Humanity](https://cardsagainsthumanity.com/) company, but you should absolutely [buy their game](https://store.cardsagainsthumanity.com/) because it's a lot more fun in person. Remixed under [Creative Commons BY-NC-SA 2.0 license](https://creativecommons.org/licenses/by-nc-sa/2.0/).

The cards were imported from [json-against-humanity](https://github.com/crhallberg/json-against-humanity).

## Development setup

This is a Ruby on Rails application that requires Ruby, PostgreSQL and Redis.

1. Install Ruby, preferrably with [`rbenv`](https://github.com/rbenv/rbenv)
2. Install dependencies:

```sh
$ gem install bundler
$ bundle install
$ yarn install
```

3. Create, migrate and populate the database:

```sh
$ bundle exec rails db:create db:migrate db:seed
```

4. Start the web server and the background job processor:

```sh
$ bundle exec rails server
$ bundle exec sidekiq
```

Streaming game updates to clients goes through background jobs, so Sidekiq is required (otherwise, players need to refresh the page manually).

Alternatively, you can use an application process manager to start both the web server and background job processor. [Foreman](http://blog.daviddollar.org/2011/05/06/introducing-foreman.html) is a good Ruby-based option, but there are many alternatives to suit your needs:

```sh
$ gem install foreman
$ foreman start web=1,worker=1
```

5. Open a browser to [http://localhost:3000](http://localhost:3000)

## Docker setup

This repo includes a `Dockerfile` and `docker-compose.yml` for local development.

1. Build the images:

```sh
docker compose build --no-cache
```

2. Edit the environment variables:

```sh
cp .env.example .env
vim .env
```

3. Precompile assets the create, migrate, and seed the database:

```sh
docker compose --env-file .env run --rm web bundle exec rails db:create db:migrate db:seed assets:precompile
```

4. Start the web and background worker services with your `.env` file:

```sh
docker compose --env-file .env up
```

4. On your browser, go to [http://localhost:3000](http://localhost:3000)

5. To stop the containers:

```sh
docker compose down -v
```

## Running the test suite

```sh
bundle exec rspec
```
