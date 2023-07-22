release: bin/rails db:migrate assets:precompile & cp /usr/lib/ssl/certs/ca-certificates.crt ./lib/
web: bin/rails server -p ${PORT:-5000} -e $RAILS_ENV
