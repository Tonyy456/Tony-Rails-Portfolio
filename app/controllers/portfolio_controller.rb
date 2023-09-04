class PortfolioController < ApplicationController
  # get /portfolio params: filter:array-string, sort:string, 
  def index
    clean_up_blobs
    @projects = Project.all
  end
end
