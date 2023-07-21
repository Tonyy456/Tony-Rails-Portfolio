class PortfolioController < ApplicationController
  def index
    puts "Testing I can log stuff here"
    clean_up_blobs
    @projects = Project.all
  end
end
