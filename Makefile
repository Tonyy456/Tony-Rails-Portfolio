all:
	rails db:migrate assets:precompile
	rails s
