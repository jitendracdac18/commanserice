package com.microservice.app;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@EnableDiscoveryClient
public class AppServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(AppServiceApplication.class, args);
    }
}

@RestController
class HealthController {
    @GetMapping("/")
    public String home() {
        return "App Service is running!";
    }

    @GetMapping("/health")
    public String health() {
        return "OK";
    }
}
