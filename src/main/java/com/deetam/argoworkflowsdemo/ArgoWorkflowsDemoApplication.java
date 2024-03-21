package com.deetam.argoworkflowsdemo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
public class ArgoWorkflowsDemoApplication {

	public static void main(String[] args) {
		SpringApplication.run(ArgoWorkflowsDemoApplication.class, args);
	}

	@RestController
	static class TestController {
		@GetMapping("/hi")
		public String test() {
			return "Hello World --- v3";
		}
	}
}
