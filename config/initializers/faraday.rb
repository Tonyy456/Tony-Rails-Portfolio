# config/initializers/faraday.rb
Faraday.new(url: 'https://api.example.com') do |faraday|
    faraday.ssl.verify = true
    faraday.ssl.ca_file = Rails.root.join('lib/ca-certificates.crt').to_s
    faraday.ssl.ca_path = Rails.root.join('lib/ca-certificates.crt').to_s
    faraday.request :url_encoded
    faraday.adapter Faraday.default_adapter
  end
  