# config/initializers/faraday.rb

Faraday.new(url: ENV['FARADAY_URL']) do |faraday|
    faraday.ssl.verify = true
    faraday.ssl.ca_file = ENV['CA_PATH']
    faraday.ssl.ca_path = ENV['CA_PATH']
    faraday.request :url_encoded
    faraday.adapter Faraday.default_adapter
  end
  