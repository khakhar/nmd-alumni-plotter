# NMD Alumni Plotter

## Install

* Install dependencies using `bundler`.

        bundle install

* Set db credentials. Use `config/database.yml.sample` as a template to create `config/database.yml`.

* Migrate the database and seed it with data.

        rake db:migrate db:seed

* Start the server

        bundle exec rails s

## Utils

* Rake task to populate database with samples

        bundle exec rake populate_samples

* Rake task to clear user entered data from the database

        bundle exec rake clear_data


#### Generate placeholders from command line

    convert -size 50x50 xc:skyblue -fill skyblue -stroke skyblue -draw "rectangle 0,0 50,50" draw_rect.gif
