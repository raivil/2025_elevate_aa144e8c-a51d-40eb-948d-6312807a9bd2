This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

  - 3.3.5

* System dependencies
  - Postgresql 15+
* Configuration
  - Using defaults as much as possible.
* Database creation
  - See Database initialization
* Database initialization
```
bundle exec rails db:drop db:create db:migrate
```
* Seeding the database
```
$ bundle exec rails db:seed
```

* How to run the test suite

```
bundle exec rspec
```
 Coverage report is generated in `coverage/` directory.

* Services (job queues, cache servers, search engines, etc.)
 - No additional services are implemented.

* Deployment instructions

  - Run the app with `bundle exec rails s`


### Credentials

Default credentials are stored in `config/credentials.yml.enc`.

To edit the credentials run:
bundle exec rails credentials:edit
bundle exec rails credentials:edit -e test



### Accessing the API

#### Basic auth is required to access the API.
```
curl -H "Authorization: Bearer super_secret_token" http://localhost:3000/api/v1/roles
```

#### Available endpoints and examples

- `GET http://127.0.0.1:3000/api/v1/roles`
```
curl --location 'http://127.0.0.1:3000/api/v1/roles' --header 'Authorization: Bearer super_secret_token'
```
- `POST http://127.0.0.1:3000/api/v1/roles`
```
curl --location 'http://127.0.0.1:3000/api/v1/roles' \
--header 'Token: super_secret_token' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer super_secret_token' \
--data '{ "role": { "name": "Senior Developer 1" } }'
```

- `GET http://127.0.0.1:3000/api/v1/team_membership/:team_id/:user_id`
```
curl --location --request GET 'http://127.0.0.1:3000/api/v1/team_membership/8a49d79b-9885-434b-a636-8322b1eb4367/5b83e871-fb94-4788-ad4b-3bf6a2f68f0b' \
--header 'Token: super_secret_token' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer super_secret_token' \
--data '{
    "user_id": "5b83e871-fb94-4788-ad4b-3bf6a2f68f0b",
    "team_id": "8a49d79b-9885-434b-a636-8322b1eb4367"
}'
```
- `GET http://127.0.0.1:3000/api/v1/team_memberships`
```
curl --location --request GET 'http://127.0.0.1:3000/api/v1/team_memberships' \
--header 'Token: super_secret_token' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer super_secret_token' \
--data '{
    "role_id": "1fe03baa-fe36-4c39-9fc7-17b74af7fb0e"
}'
```
- `POST http://127.0.0.1:3000/api/v1/team_memberships`
```
curl --location 'http://127.0.0.1:3000/api/v1/team_memberships' \
--header 'Token: super_secret_token' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer super_secret_token' \
--data '{
    "team_membership": {
        "user_id": "5b83e871-fb94-4788-ad4b-3bf6a2f68f0b",
        "team_id": "8a49d79b-9885-434b-a636-8322b1eb4367",
        "role_id": "1fe03baa-fe36-4c39-9fc7-17b74af7fb0e"
    }

}'
```
