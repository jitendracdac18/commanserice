#!/bin/bash

echo "Building Eureka Server..."
cd eureka-server
mvn clean package -DskipTests
if [ $? -ne 0 ]; then
    echo "Failed to build Eureka Server"
    exit 1
fi
cd ..

echo "Building App Service..."
cd app
mvn clean package -DskipTests
if [ $? -ne 0 ]; then
    echo "Failed to build App Service"
    exit 1
fi
cd ..

echo "Build completed successfully!"
echo "You can now run: docker-compose up -d --build"
