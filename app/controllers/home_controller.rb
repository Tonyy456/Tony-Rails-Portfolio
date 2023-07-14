class HomeController < ApplicationController
  def index
    #flash[:notice] = 'Bro what are you doing?!?!'
    @banner_videos = HomeVideo.all
  end

  def admin
    admin_only
  end
end
