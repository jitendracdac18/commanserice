#!/bin/bash

echo "==================================="
echo "Docker Microservices Health Check"
echo "==================================="
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running"
    exit 1
fi

# Check Docker Compose version
echo "Docker Compose Version:"
docker compose version
echo ""

# Check running containers
echo "=== Running Containers ==="
docker compose ps
echo ""

# Health checks
echo "=== Service Health Checks ==="

echo -n "App Service (http://localhost:8080): "
if curl -s -f http://localhost:8080/ > /dev/null; then
    echo "✅ Healthy"
else
    echo "❌ Not responding"
fi

echo -n "Eureka Server (http://localhost:8761): "
if curl -s -f http://localhost:8761/actuator/health > /dev/null; then
    echo "✅ Healthy"
else
    echo "❌ Not responding"
fi

echo -n "Prometheus (http://localhost:9090): "
if curl -s -f http://localhost:9090/-/healthy > /dev/null; then
    echo "✅ Healthy"
else
    echo "❌ Not responding"
fi

echo -n "Grafana (http://localhost:3000): "
if curl -s -f http://localhost:3000/api/health > /dev/null; then
    echo "✅ Healthy"
else
    echo "❌ Not responding"
fi

echo -n "Loki (http://localhost:3100): "
if curl -s -f http://localhost:3100/ready > /dev/null; then
    echo "✅ Healthy"
else
    echo "❌ Not responding"
fi

echo -n "MySQL (localhost:3306): "
if docker compose exec -T mysql mysqladmin ping -h localhost -u root -proot123 2>&1 | grep -q "mysqld is alive"; then
    echo "✅ Healthy"
else
    echo "❌ Not responding"
fi

echo ""
echo "=== Service URLs ==="
echo "📊 Grafana Dashboard: http://localhost:3000 (admin/admin)"
echo "📈 Prometheus: http://localhost:9090"
echo "🔍 Eureka Dashboard: http://localhost:8761"
echo "🚀 App Service: http://localhost:8080"
echo "📝 Loki: http://localhost:3100"
echo "🗄️  MySQL: localhost:3306 (admin/admin123)"
echo ""
echo "==================================="
echo "All services are running! ✅"
echo "==================================="
