Player for Web Pure Data patches Development Environment
=================

## Requirements

To run this project, you need to have:

- [Git](https://git-scm.com/)
- [Nvm](https://github.com/nvm-sh/nvm)
- [Yarn](https://yarnpkg.com/)
- [Mkcert](https://github.com/FiloSottile/mkcert)
- [Docker](https://www.docker.com/)

## Setup

To start the project:

    eval `ssh-agent`
    make

Open `https://localhost:8443` in your browser
Open `http://localhost:8025` in your browser to access MailHog

Clone [Player for Web Pure Data](https://github.com/opengeekv2/player-for-web-pure-data-patches) into public/wp-content/plugins/ or your own fork of the plugin.

The repositories will be independent because the plugin folder is ignored.

Develop whatever thing you wanat you work on and push it back periodically to your fork.

Remember to periodically run:
* make phpunit
* make php-cs
* make php-cs-fix
* make phpstan
* make psalm

to check the quallity of you pull request in advance.

If any of them gives you an error it could possibly mean the pull request will not pass the checks put in place.

Once you are satisfied with your work and you believe it meets the requirements to fix the issue ask for a pull request in [Player for Web Pure Data](https://github.com/opengeekv2/player-for-web-pure-data-patches).

Enjoy all the comands in the Makefile to do your life easier while running commands inside the Docker.

Thanks for contributing.
