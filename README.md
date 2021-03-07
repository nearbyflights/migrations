## migrations

This repo stores the SQL migrations used by the [ORY Hydra](https://github.com/ory/hydra) (login system) database.

### Development

#### Logic

This uses [`flyway`](https://flywaydb.org/) for managing SQL migrations. 

#### Running

Set the following environment variables in the `.env` file:

- `POSTGRES_URL`
- `POSTGRES_LOGIN_DB`: ORY Hydra database.
- `POSTGRES_USER`
- `POSTGRES_PASSWORD`

And then run the Docker file:

```
docker build -t migrations . && docker run --rm --env-file .env --name migrations-standalone migrations
```





