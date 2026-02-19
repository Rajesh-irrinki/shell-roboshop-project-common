# shell-roboshop-project-common

# RoboShop Deployment using Shell Scripting 🚀

## Overview
This repository contains shell scripts for the deploying RoboShop microservices application. By treating infrastructure as code, these scripts replace manual installation steps with a fast, reliable, and repeatable automated process. 

## Features
* **Automated Setup:** Installs and configures all required dependencies, databases, and application services.
* **Centralized Configuration:** Uses a common script approach to manage shared variables and functions, reducing code duplication.
* **Error Handling:** Includes built-in checks to ensure scripts exit cleanly if a step fails.
* **Color-Coded Logging:** Provides clear, readable output in the terminal to track the installation progress and identify issues quickly.

## Architecture Components
The RoboShop application consists of several interconnected microservices. These scripts automate the setup for the following layers:

* **Web Layer:** Nginx (Frontend)
* **Application Layer:** Catalogue, User, Cart, Shipping, Payment, Dispatch
* **Database Layer:** MongoDB, Redis, MySQL, RabbitMQ

## Prerequisites
Before executing any scripts, ensure your environment meets the following requirements:
* Operating System: CentOS 8 or Amazon Linux 2023.
* Access: Root privileges or a user with `sudo` permissions.
* Tools: Git installed on the target server.

## Quick Start Guide

1. **Clone the Repository:**
   Download the scripts to your server.
   ```bash
   git clone https://github.com/Rajesh-irrinki/shell-roboshop-project-common.git
   cd shell-roboshop-project-common