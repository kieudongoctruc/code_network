# CodeNetwork Restful API

Ruby on Rails backend API to serve for coders's social network application

## Setup instructions

1. Install bundler gem:
    ```
    $ gem install bundler
    ```
2. Install all gem dependences:
    ```
    $ bundle install
    ```
    **Note**: If on Mac, you need to install imagemagick 6: `brew install imagemagick@6 && brew link imagemagick@6 --force`

    **Note**: If on Mac, nokogiri doesn't install because of missing libxml2, run: `xcode-select --install`

3. Database creation
    ```
    $ bundle exec rake db:create
    ```
    **Note**: You need to setup your database credentials on `database.yml`
    ```
    $ psql postgres
    ```

    ```
    CREATE ROLE postgres WITH LOGIN PASSWORD 'postgres';
    ALTER ROLE postgres CREATEDB;
    ```

4. Database initialization
    ```
    $ bundle exec rake db:migrate
    ```

5. Serve It Up
    ```sh
    $ rails s
    ```
    **Note**: If you want to use webrick, you just need to prefix the command with the server name: `rails s webrick`

    ```

6. Test
    Prepare the database for the test environment
    ```sh
    $ bundle exec rake db:test:prepare
    ```
    Run the tests
    ```sh
    $ rspec spec/ -f d -c
    ```

    1. run all examples in spec folder
    2. `-f d` option will show the results in documentation format (group and example names)
    3. `c` option will enable color in the output
    4. You can see test coverage at coverage/index.html
