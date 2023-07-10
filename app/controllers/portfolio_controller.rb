class PortfolioController < ApplicationController
  def index
    @pins = Pin.all
  end
end
