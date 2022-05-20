# Rails Engine (lite)


## About this Project

Project specifications [Rails Engine lite project](https://backend.turing.edu/module3/projects/rails_engine_lite) used for Turing's Backend Module 3.

 Rails Engine Lite is a pure backend API with CRUD endpoints for a merchant based database.

 ## Learning Goals
- Use serializers to format JSON responses
- Test API exposure
- Use SQL and ActiveRecord to gather data

## Setup for the use of the project

1. Fork and Clone the repo
2. `cd` into the project directory (rails-engine)
3. Install gem packages: `bundle install`
4. Setup the database: `rails db:{drop,create,migrate,seed}`
5. This project uses a .pgdump to populate the database, to populate the rails schema.rb run: `rails db:schema:dump`

## Versions
- Ruby 2.7.2
- Rails 5.2.8

## API Endpoints
- http://localhost:3000/api/v1/merchants
- http://localhost:3000/api/v1/merchants/{{merchant_id}}
- http://localhost:3000/api/v1/merchants/{{merchant_id}}/items
- http://localhost:3000/api/v1/items
- http://localhost:3000/api/v1/items/{{item_id}}
- (POST) http://localhost:3000/api/v1/items
- (PUT) http://localhost:3000/api/v1/items/{{item_id}}
- http://localhost:3000/api/v1/items/{{item_id}}/merchant
- http://localhost:3000/api/v1/merchants/find?name
- http://localhost:3000/api/v1/merchants/find_all?name
- http://localhost:3000/api/v1/items/find?name
- http://localhost:3000/api/v1/items/find?name_all
- http://localhost:3000/api/v1/items/find?min_price
- http://localhost:3000/api/v1/items/find_all?min_price
- http://localhost:3000/api/v1/items/find?max_price
- http://localhost:3000/api/v1/items/find_all?max_price
- http://localhost:3000/api/v1/items/find?min_price&max_price
- http://localhost:3000/api/v1/items/find_all?min_price&max_price
