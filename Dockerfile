FROM adoptopenjdk:11-jre-hotspot-focal

# Add the flyway user and step in the directory
RUN adduser --system --home /flyway --disabled-password --group flyway
WORKDIR /flyway

# Change to the flyway user
USER flyway

ENV FLYWAY_VERSION 7.7.0

RUN curl -L https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}.tar.gz -o flyway-commandline-${FLYWAY_VERSION}.tar.gz \
  && tar -xzf flyway-commandline-${FLYWAY_VERSION}.tar.gz --strip-components=1 \
  && rm flyway-commandline-${FLYWAY_VERSION}.tar.gz

COPY . /flyway/sql
ENTRYPOINT []

CMD /flyway/flyway -url=jdbc:postgresql://${POSTGRES_URL}/${POSTGRES_LOGIN_DB} -user=${POSTGRES_USER} -password=${POSTGRES_PASSWORD} -baselineOnMigrate=true -sqlMigrationPrefix=patch_ -connectRetries=5 migrate
