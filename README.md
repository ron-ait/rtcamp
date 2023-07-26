# Bash Script for Managing WordPress Sites with Docker
This bash script simplifies the process of creating, enabling, disabling, and deleting WordPress sites using Docker containers. It includes functions to check if Docker and Docker Compose are installed and install them if necessary. The script also allows you to manage WordPress sites by starting, stopping, and removing containers for individual sites.





## Prerequisites
Before using this script, ensure that you have the following prerequisites installed on your system:

Docker: Visit the official Docker website for installation instructions.
Docker Compose: Follow the Docker Compose installation guide for installation.






## How to Use
Download the script file and save it as **wordpress_docker_manager.sh**.


Make the script executable using the following command:

__chmod +x wordpress_docker_manager.sh__

Run the script with the appropriate subcommand and site name (if applicable):


To create a new WordPress site with Docker:

__./wordpress_docker_manager.sh create example.com__

This command will create a new WordPress site with the domain name example.com.


To enable an existing WordPress site (start containers):

__./wordpress_docker_manager.sh enable example.com__


To disable an existing WordPress site (stop containers):

__./wordpress_docker_manager.sh disable example.com__


To delete an existing WordPress site (stop containers and remove local files):

__./wordpress_docker_manager.sh delete example.com__




### Note: Replace example.com with the desired domain name for your WordPress site.






## Function Descriptions
check_command(): Checks if a command is available on the system.

install_docker(): Installs Docker on the system if it is not already installed.

install_docker-compose(): Installs Docker Compose on the system if it is not already installed.

create_wordpress_site(): Creates a new WordPress site using Docker Compose. It generates a docker-compose.yml file based on the provided site name and starts the containers.

enable_disable_site(): Enables or disables a WordPress site by starting or stopping the containers, respectively.

delete_site(): Deletes a WordPress site by stopping containers and removing the associated docker-compose.yml file.







# Example Usage


### Check if Docker is installed and install it if not
./wordpress_docker_manager.sh

### Check if Docker Compose is installed and install it if not
./wordpress_docker_manager.sh

### Create a new WordPress site
./wordpress_docker_manager.sh create mywebsite.com

### Enable an existing WordPress site
./wordpress_docker_manager.sh enable mywebsite.com

### Disable an existing WordPress site
./wordpress_docker_manager.sh disable mywebsite.com

### Delete an existing WordPress site
./wordpress_docker_manager.sh delete mywebsite.com
Please ensure that you have appropriate permissions to execute the script and manage Docker containers on your system.


If you encounter any issues or have suggestions for improvements, please feel free to contribute or report them on the __GitHub repository__. We welcome any feedback to enhance the script further. Happy WordPress Docker management!
