# Auth & Security

## Authentication

Authentication is handled by [OAuth 2](https://www.digitalocean.com/community/tutorials/an-introduction-to-oauth-2) and enforced using [JSON Web Tokens (JWTs)](https://jwt.io/introduction/). We use the [fastapi-jwt-auth](https://indominusbyte.github.io/fastapi-jwt-auth/) FastAPI extension to manage this cleanly on our behalf.

OAuth 2 authentication flows can be started by sending a GET request to `/api/login?provider={provider_key}`, where `provider_key` is the name of one of the providers defined in `auth.py`. Once the authentication flow is completed, the API will automatically set a cookie on the client containing the JWT, which must be included in each subsequent HTTP request.

This can be tested using the `/api/profile` endpoint, which is protected by authentication (and will return a 401 if authentication is missing)

## Local Development

In order to use authentication, you must have access to the various credentials of the OAuth clients the application uses. There are two ways to get them:

### Get Secrets from GCP Secret Manager using Cloud SDK Profile

...still need to figure this out. Ideally does not involve any explicit setting of keys and their paths and works as the rational default. Would support granting individual access (i.e. making it much more secure than shared Service Account keys).

GCP docs for logging into the CLI are [here](https://cloud.google.com/sdk/gcloud/reference/auth/login). To make that work automagically, we'll need to update either `api/Dockerfile` or `docker-compose.override.yml` to pull the host's implicit service key into the container either by copying it over or setting the `GOOGLE_APPLICATION_CREDENTIALS` environment variable inside the container to something that points to the correct place on the host.

### Get Secrets from GCP Secret Manager using Service Account Key (Recommended)

Including a Service Account key (with the correct permissions) called `gcp_credentials.json` in the `api/` folder will automatically be pulled in correctly when the API Docker image builds. To rebuild that image to ensure this has happened, use `make recreate-api` followed by `make up`. __Do not__ include that service key in your commits; it's already been added to the .gitignore to help prevent that.

Service Accounts are shared accounts that grant access to our secrets, thus these shared keys must be handled with care. They are refreshed often. Reach out to one of the GCP admins in our team Slack channel in order to get it.

### Manually Configure OAuth Client Credentials

If you are having trouble accessing the GCP Secret Manager (or need to do testing using different OAuth credentials for whatever reason), you can manually configure a supported OAuth client for local development (see below). __Do not__ commit your manually added OAuth credentials to our GitHub repo, otherwise they will be on the public internet forever.

To manually configure one or more OAuth clients, the following configuration must be defined for the `development` environment in `config.yaml`:

```
auth:
  import_auth_credentials_from_secret_store: False
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

You must ensure that `import_auth_credentials_from_secret_store` has been set to `false`, otherwise the API will automatically attempt to import them from GCP's secret manager and use those credentials instead.