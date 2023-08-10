# Tony-Rails-Portfolio
Deployed at: www.antdev.cc

# References
* [Image Upload](https://www.youtube.com/watch?v=1cw6qO1EYGw)  
* [Make rails program a sub page](https://stackoverflow.com/questions/39006919/adding-a-rails-herokuapp-to-a-subpage-of-an-existing-page-domain)
* [Devise README](https://github.com/heartcombo/devise)
* [Admin Only Features](https://www.youtube.com/watch?v=H8ZfAxfE3yI)
* [Using Strava's API](https://developers.strava.com/docs/getting-started/)
* [Strava Documentation](https://developers.strava.com/docs/reference/)

# Services Used
* Amazon S3 Bucket
* Heroku Webhosting
* Heroku PostgreSQL
* Heroku Bucketeer
* Namecheap

# Software
* Ruby 3.2.0
* Rails 7.0.5.1
* Bootstrap 5.3.0

# Notable Gems
* "devise", "~> 4.9"
* "aws-sdk-s3", "~> 1.129"
* "image_processing", "~> 1.2"
* "pg", "~> 1.1"

# Software and Hosting Overview
This application was developed using Ruby on Rails. To host the website, Heroku was used  
with PostgreSQL for the database management. I have a single web dyno managing the website. 
Because I want to be able to upload images and more projects and have it scale infinitely,   
and Amazon s3 bucket was used. In total this is costing around $17/mo. Heroku also offers 
free SSL certificates. The Domain name was purchased from Namecheap for around $4/yr for 5 years.

# Installation
```sh
# install any dependencies for the notable gems above
bundle install
rails db:migrate assets:precompile
```

# Run developement Server
```sh
rails server
```

# Potential Future Features
- database backup (dont want to add a bunch of projects and lose random work)
- Grocery List Maker
