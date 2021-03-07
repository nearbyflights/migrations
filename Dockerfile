FROM flyway/flyway:latest-alpine
COPY . /flyway/sql
ENTRYPOINT []
CMD /flyway/flyway -url=jdbc:postgresql://${POSTGRES_URL}/${POSTGRES_LOGIN_DB} -user=${POSTGRES_USER} -password=${POSTGRES_PASSWORD} -baselineOnMigrate=true -sqlMigrationPrefix=patch_ -connectRetries=5 migrate
