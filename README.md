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

### Running the test suite

```sh
bundle exec rspec
```

5. Open a browser to [http://localhost:3000](http://localhost:3000)

## Run on Docker

Make sure you have [Docker Engine](https://docs.docker.com/engine/) installed. To configure the containers, you may modify the files `Dockerfile` and `docker-compose.yml`.

1. Build the image:

```sh
docker compose build [--no-cache]
```

2. Create you own environment variables:

```sh
cp .env.example .env
vim .env
```

3. Precompile assets then create, migrate, and seed the database:

```sh
docker compose [--env-file .env] run --rm web bundle exec rails assets:precompile db:create db:migrate db:seed 
```

4. Optional, run the test suite:

```sh
docker compose [--env-file .env] run --rm web bundle exec rspec
```

4. Start the web and worker services:

```sh
docker compose [--env-file .env] up
```

If successful, you should see something like this:

```sh
web-1     | => Booting Puma
web-1     | => Rails 7.0.4.3 application starting in development 
web-1     | => Run `bin/rails server --help` for more startup options
worker-1  | 2026-01-08T14:04:35.732Z pid=1 tid=e0h INFO: Booted Rails 7.0.4.3 application in development environment
worker-1  | 2026-01-08T14:04:35.732Z pid=1 tid=e0h INFO: Running in ruby 3.3.2 (2024-05-30 revision e5a195edf6) [aarch64-linux]
worker-1  | 2026-01-08T14:04:35.732Z pid=1 tid=e0h INFO: See LICENSE and the LGPL-3.0 for licensing details.
worker-1  | 2026-01-08T14:04:35.732Z pid=1 tid=e0h INFO: Upgrade to Sidekiq Pro for more features and support: https://sidekiq.org
worker-1  | 2026-01-08T14:04:35.732Z pid=1 tid=e0h INFO: Sidekiq 7.2.2 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://redis:6379/1"}
worker-1  | 2026-01-08T14:04:35.735Z pid=1 tid=e0h INFO: Sidekiq 7.2.2 connecting to Redis with options {:size=>10, :pool_name=>"default", :url=>"redis://redis:6379/1"}
web-1     | Puma starting in single mode...
web-1     | * Puma version: 6.4.2 (ruby 3.3.2-p78) ("The Eagle of Durango")
web-1     | *  Min threads: 5
web-1     | *  Max threads: 5
web-1     | *  Environment: development
web-1     | *          PID: 1
web-1     | * Listening on http://0.0.0.0:3000
web-1     | Use Ctrl-C to stop
db-1      | 2026-01-08 15:08:37.556 CET [26] LOG:  checkpoint starting: time
db-1      | 2026-01-08 15:08:37.668 CET [26] LOG:  checkpoint complete: wrote 4 buffers (0.0%); 0 WAL file(s) added, 0 removed, 0 recycled; write=0.106 s, sync=0.002 s, total=0.113 s; sync files=3, longest=0.001 s, average=0.001 s; distance=0 kB, estimate=0 kB
redis-1   | 1:M 08 Jan 2026 14:08:38.027 * 100 changes in 300 seconds. Saving...
redis-1   | 1:M 08 Jan 2026 14:08:38.028 * Background saving started by pid 22
```

4. On your browser, go to [http://localhost:3000](http://localhost:3000) to start playing with your friends.

5. To stop the containers, execute:

```sh
docker compose down [-v]
```

When deploying in production, it is highly advised to serve the application behind nginx with SSL certificates. More instructions [here](https://medium.com/@christian.ferreir4/setup-production-environment-rails-7-docker-compose-puma-nginx-reverse-proxy-bb19c5c324d5).