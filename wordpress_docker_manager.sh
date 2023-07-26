#!/bin/bash

# Function to check if a command is available on the system
function check_command() {
	command -v "$1" >/dev/null
}

# Function to install Docker on the system
function install_docker() { 
    echo "docker is not installed" 
    echo "installing docker" 

    # Update package index
    sudo apt-get update

    # Install required packages for adding Docker repository
    sudo apt-get install ca-certificates curl gnupg -y  

    # Create directory for the Docker repository keyring
    sudo install -m 0755 -d /etc/apt/keyrings

    # Add Docker repository key to the keyring
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    # Add Docker repository to the package sources list
    echo \
      "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Update package index again to include the Docker repository
    sudo apt-get update

    # Install Docker packages
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

    # Enable and start Docker service
    sudo systemctl enable docker 
    sudo systemctl start docker 
}

# Function to install Docker Compose on the system
function install_docker-compose() {
    echo "Installing Docker Compose..."

    # Download Docker Compose binary to /usr/local/bin and make it executable
    sudo curl -fsSL https://github.com/docker/compose/releases/latest/download/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

    echo "Docker Compose has been installed."
}

# Function to create a new WordPress site using Docker Compose
function create_wordpress_site() {
    echo "Creating WordPress site: $1"

    # Define the Docker Compose configuration for the WordPress site
    cat <<EOL >docker-compose.yml
version: "3"
services:
  wordpress:
    image: wordpress:latest
    ports:
      - "80:80"
    environment:
      - WORDPRESS_DB_HOST=mysql
      - WORDPRESS_DB_NAME=wordpress
      - WORDPRESS_DB_USER=root
      - WORDPRESS_DB_PASSWORD=password
    volumes:
      - wordpress:/var/www/html
  mysql:
    image: mysql:latest
    environment:
      - MYSQL_ROOT_PASSWORD=password
      - MYSQL_DATABASE=wordpress
    volumes:
      - mysql:/var/lib/mysql
volumes:
  wordpress:
  mysql:
EOL

    # Start the containers
    docker-compose up -d

    # Add an entry to /etc/hosts for example.com
    echo "127.0.0.1 example.com" | sudo tee -a /etc/hosts

    echo "WordPress site '$1' has been created and can be accessed at http://example.com"
}

# Function to enable or disable the WordPress site (stop/start containers)
function enable_disable_site() {
    action="$1"
    case $action in
        enable)
            echo "Enabling the WordPress site..."
            docker-compose start
            ;;
        disable)
            echo "Disabling the WordPress site..."
            docker-compose stop
            ;;
        *)
            echo "Invalid command. Usage: $0 enable|disable"
            exit 1
            ;;
    esac
}

# Function to delete the WordPress site (stop containers and remove local files)
function delete_site() {
    echo "Deleting the WordPress site..."
    docker-compose down
    rm -f docker-compose.yml
    echo "WordPress site has been deleted."
}

# Check if Docker is installed and install it if not
if ! check_command docker
then 
    install_docker 
else 
    echo "docker is already installed"
fi

# Check if Docker Compose is installed and install it if not
if ! check_command docker-compose
then 
    install_docker-compose 
else 
    echo "docker-compose is already installed"
fi

# Handle different subcommands
case $1 in 
    "create")
        create_wordpress_site "$2"
        ;;
    "enable"|"disable")
        enable_disable_site "$1" "$2"
        ;;
    "delete")
        delete_site "$2"
        ;;
    *)
        echo "subcommand not found, command must be $0 <create|enable|disable|delete> <site-name>"
        exit 1 
        ;;
esac
