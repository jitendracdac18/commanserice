# Docker Microservices Monitoring Setup

This project provides a complete Docker-based microservices monitoring solution with:
- **Prometheus** - Metrics collection and monitoring
- **Grafana** - Visualization and dashboards
- **Loki** - Log aggregation
- **MySQL** - Database service
- **Eureka Server** - Service discovery
- **App Service** - Sample microservice application

## Prerequisites

- Docker Desktop or Docker Engine installed
- Docker Compose v2.0 or higher
- Java 17 (for local development)
- Maven 3.6+ (for local development)

## Quick Start

### 1. Build the Java applications

```bash
# Build Eureka Server
cd eureka-server
mvn clean package -DskipTests
cd ..

# Build App Service
cd app
mvn clean package -DskipTests
cd ..
```

### 2. Start all services

```bash
docker compose up -d --build
```

Or simply (if you've already built):

```bash
docker compose up -d
```

### 3. Access the services

- **Grafana**: http://localhost:3000 (admin/admin)
- **Prometheus**: http://localhost:9090
- **Eureka Server**: http://localhost:8761
- **App Service**: http://localhost:8080
- **Loki**: http://localhost:3100

### 4. Verify all services are running

```bash
./health-check.sh
```

### 5. Stop all services

```bash
docker compose down
```

### 6. Stop and remove all data

```bash
docker compose down -v
```

## Service Details

### Prometheus
- Scrapes metrics from all services
- Configuration: `prometheus/prometheus.yml`
- Data stored in Docker volume: `prometheus-data`

### Grafana
- Pre-configured with Prometheus and Loki datasources
- Datasource config: `grafana/provisioning/datasources/`
- Data stored in Docker volume: `grafana-data`

### Loki
- Collects and stores logs from all services
- Configuration: `loki/loki-config.yml`
- Data stored in Docker volume: `loki-data`

### MySQL
- Database for microservices
- Port: 3306
- Database: microservices
- User: admin / Password: admin123
- Root Password: root123

## Troubleshooting

### Issue: 403 Forbidden when pulling images
**Solution**: The docker-compose.yml uses specific image versions to avoid rate limiting issues. If you still encounter problems:
1. Login to Docker Hub: `docker login`
2. Use a different registry mirror
3. Wait a few hours and retry (rate limit reset)

**Fixed Issues:**
- Changed from MariaDB to MySQL 8.0 official image (more reliable)
- Changed from openjdk:17-slim to eclipse-temurin:17-jre-alpine (OpenJDK images deprecated)

### Issue: Services not starting
**Solution**: Check logs with:
```bash
docker compose logs -f [service-name]
```

### Issue: Port already in use
**Solution**: Stop conflicting services or change ports in docker-compose.yml

### Issue: Loki shows "Ingester not ready"
**Solution**: This is normal during startup. Wait 15-20 seconds for Loki to fully initialize.

## Development

### Building Services Locally

```bash
# Eureka Server
cd eureka-server
mvn spring-boot:run

# App Service
cd app
mvn spring-boot:run
```

### Adding New Microservices

1. Create a new directory for your service
2. Add a Dockerfile
3. Add service configuration to docker-compose.yml
4. Update prometheus.yml to scrape metrics
5. Rebuild: `docker-compose up -d --build`

## Architecture

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│   Grafana   │────▶│  Prometheus  │────▶│   Services  │
│  (Dashb.)   │     │   (Metrics)  │     │ (Eureka,App)│
└─────────────┘     └──────────────┘     └─────────────┘
       │                                         │
       │            ┌──────────────┐            │
       └───────────▶│     Loki     │◀───────────┘
                    │    (Logs)    │
                    └──────────────┘
                           │
                           ▼
                    ┌──────────────┐
                    │    MySQL     │
                    │  (Database)  │
                    └──────────────┘
```

## License

This project is provided as-is for demonstration purposes.
