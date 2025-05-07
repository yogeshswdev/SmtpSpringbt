package com.yogesh.smtp;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class SmtpApplication implements CommandLineRunner {

	@Autowired
	private EmailService emailService;

	public static void main(String[] args) {
		SpringApplication.run(SmtpApplication.class, args);
	}

	@Override
	public void run(String... args) throws Exception {
		emailService.sendEmail("recipient@example.com", "Test Subject", "This is a test email.");
		System.out.println("Email sent successfully!");
	}
}
