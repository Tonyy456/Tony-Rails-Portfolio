class PortfolioController < ApplicationController
  def index
    puts "Testing I can log stuff here"
    clean_up_blobs
    @pins = Pin.all
  end
end
