# Auth & Security

## Authentication

Authentication is handled by [OAuth 2](https://www.digitalocean.com/community/tutorials/an-introduction-to-oauth-2) and enforced using [JSON Web Tokens (JWTs)](https://jwt.io/introduction/).

OAuth 2 authentication flows can be started by sending a GET request to `/api/login?provider={provider_key}`, where `provider_key` is the name of one of the providers defined in `auth.py`. Once the authentication flow is completed, the client will recieve a JWT containing an access token, which must be passed to the API using Bearer Authorization (i.e. sending the request with the following header: `Authorization: Bearer {jwt_access_token}`)

This can be tested using the `/api/profile` endpoint, which is protected by authentication (and will return a 401 if authentication is missing)

## Local Development

In order to use authentication, the following configuration must be defined in that particular environment in `config.yml` (e.g. `development` for local dev):

```
auth:
  jwt:
    secret: {some_randomly_generated_secret}
  google:
    client_id: {google_oauth_client_id}
    client_secret: {google_oauth_client_secret}
  github:
    client_id: {github_oauth_client_id}
    client_secret: {github_oauth_client_secret}
  some_other_oauth_provider: ...
```