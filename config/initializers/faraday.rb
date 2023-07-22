# config/initializers/faraday.rb
Faraday.new(url: 'https://api.example.com') do |faraday|
    faraday.ssl.verify = true
    faraday.request :url_encoded
    faraday.adapter Faraday.default_adapter
  end
  