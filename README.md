# Welcome to Kuvakehys

Kuvakehys is the application that runs [tasveer.de](http://tasveer.de). It allows you to collect photos in a group and once a certain amount of pictures is collected they are automatically printed and shipped to a configured recipient. 

## Setup

### Dependencies:

* Postgres >= 9.1 (SQLite3 works fine for development. adjust the Gemfile if you need it)
* Ruby >= 2.6
* all ruby dependencies are described in the Gemfile (please refere to the changelog of this file to check for updates)


### Installation

1) Install the bundle

    ```bash
    bundle install
    ```
2) Setup your database
     ```bash
    cp config/database.yml.example
    ```
    ```bash
    config/database.yml
    ```
    edit your database configuration
    ```bash
    vim config/database.yml 
     ```
   create, migrate and seed the database
    ```bash
    rake db:setup 
    ```

3) Setup application config using [dotenv](https://github.com/bkeepers/dotenv)
    ```bash
    cp env.example .env
    ```
   edit the needed variables
    ```bash
    vim .env
    ```

4) Run the server / done
    ```bash
    rails server
    ```
    ```bash
    open [http://localhost:3000](http://localhost:3000)
    ```
