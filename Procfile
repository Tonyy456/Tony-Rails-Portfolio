release: bin/rails db:migrate
web: heroku ps:scale worker=1
web: bin/rails server -p ${PORT:-5000} -e $RAILS_ENV
