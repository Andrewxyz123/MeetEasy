
# Team Setup Guide for PostgreSQL and Docker Network

1. **Create the Docker Network** (if it doesn’t already exist):
   ```bash
   sudo docker network create meeteasy-network
   ```

2. **Run PostgreSQL in the Docker Network**:
   - Ensure that the PostgreSQL container uses the same network and credentials:
   ```bash
   sudo docker run --name meet-easy-postgres-db --network meeteasy-network -e POSTGRES_USER=davenicholasandrew -e POSTGRES_PASSWORD=davenicholasandrew -e POSTGRES_DB=davenicholasandrew -p 5432:5432 -d postgres
   ```
   - If `meet-easy-postgres-db` already exists, start it with:
     ```bash
     sudo docker start meet-easy-postgres-db
     ```

3. **Connect the Application Container to the Network**:
   - If you are using a devcontainer or other Dockerized setup, connect it to `meeteasy-network`:
   ```bash
   sudo docker network connect meeteasy-network <application_container_name>
   ```

4. **Update `application.properties`**:
   - Confirm `spring.datasource.url` points to the `meet-easy-postgres-db` hostname:
     ```properties
     spring.datasource.url=jdbc:postgresql://meet-easy-postgres-db:5432/davenicholasandrew
     ```

5. **Run the Spring Boot Application**:
   ```bash
   mvn spring-boot:run
   ```

This guide will ensure consistent setup across team members.
