# API Application with JWT Authentication

This application provides a secure API with user authentication using JWT tokens.

## Getting Started

### Prerequisites

* Ruby version 3.3.5
* Postgresql 15+
* Bundler gem

### Setup

1. Clone the repository

```bash
git clone <repository-url>
cd <repository-directory>
```

2. Install dependencies

```bash
bundle install
```

3. Database setup

```bash
bundle exec rails db:create db:migrate
```

4. (Optional) Seed the database

```bash
bundle exec rails db:seed
```

5. Run the application

```bash
bundle exec rails server
```

The application will be available at <http://localhost:3000>

## Authentication API

The application implements a JWT-based authentication system:

### User Registration

**Endpoint:** `POST /api/user`

**Request:**

```bash
curl -X POST http://localhost:3000/api/user \
  -H "Content-Type: application/json" \
  -d '{
    "email": "example@example.com",
    "password": "strong_password"
  }'
```

**Success Response:** (201 Created)

```json
{
  "id": 1,
  "email": "example@example.com",
  "stats": { "total_games_played": 0 },
  "subscription_status": "processing"
}

```

### User Login

**Endpoint:** `POST /api/sessions`

**Request:**

```bash
curl -X POST http://localhost:3000/api/sessions \
  -H "Content-Type: application/json" \
  -d '{
    "email": "example@example.com",
    "password": "strong_password"
  }'
```

**Success Response:**

```json
{
  "token": "your.jwt.token"
}
```

### User Details and Stats

**Endpoint:** `GET /api/user`

**Request:**

```bash
curl -X GET http://localhost:3000/api/user \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Content-Type: application/json"
```

**Success Response:**

```json
{
  "user": {
    "id": 1,
    "email": "example@example.com",
    "stats": {
      "total_games_played": 5
    },
    "subscription_status": "active"
  }
}
```

Note: The `subscription_status` can be either "active", "expired", or "processing" (while being fetched).

### Accessing Protected Endpoints

After login, you'll receive a JWT token that you should include in subsequent requests:

```bash
curl -X GET http://localhost:3000/api/users \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Content-Type: application/json"
```

## Game Events API

The application allows recording of game completion events:

### Record Game Completion Event

**Endpoint:** `POST /api/user/game_events`

**Request:**

```bash
curl -X POST http://localhost:3000/api/user/game_events \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "game_event": {
      "game_name": "Brevity",
      "type": "COMPLETED",
      "occurred_at": "2025-01-01T00:00:00.000Z"
    }
  }'
```

**Success Response:** (201 Created)

```json
{
  "id": 1,
  "game_name": "Brevity",
  "event_type": "COMPLETED",
  "occurred_at": "2025-01-01T00:00:00.000Z",
  "created_at": "2025-01-01T01:00:00.000Z",
  "updated_at": "2025-01-01T01:00:00.000Z"
}
```

**Notes:**

* The `type` field must be "COMPLETED"
* The request must include a valid JWT token in the Authorization header
* The `occurred_at` timestamp should be in ISO 8601 format

## Subscription Status

The application integrates with an external billing service to provide user subscription information:

* Subscription status is included in the user details response
* Status is cached for 24 hours to minimize load on the billing service
* Background jobs are used to update subscription statuses periodically
* In case of service unavailability, a fallback status is provided

**Possible subscription status values:**

* `active`: User has an active subscription
* `expired`: User's subscription has expired
* `processing`: Status is being fetched from the billing service

## Running Tests

Run the test suite with:

```bash
bundle exec rspec
```

You can view the test coverage report in the `coverage/` directory after running the tests.

## Development

### Credentials

Default credentials are stored in `config/credentials.yml.enc`. To edit the credentials run:

```bash
bundle exec rails credentials:edit
bundle exec rails credentials:edit -e test
```

### API Documentation

See the additional endpoints documentation below:

## Notes for Developers

* This application uses Devise for user authentication with the JWT extension for API token management
* The JWT token expiration is set to 24 hours by default
* API authentication requires a valid Bearer token in the Authorization header. See curl examples.
* All API endpoints return JSON responses as requested.
* Error responses include appropriate HTTP status codes (401 for unauthorized, 422 for validation errors)

* The application uses background jobs for periodic tasks like updating subscription statuses.
* An enqueuer job was created to allow bulk updating of user statuses. This job could be enqueue to run daily.
An alternative is to the billing system send a notice to the api with the updatesd status, once it changes.

* ActiveJob configuration is minimal.

* Proper logging was not included on this application.
