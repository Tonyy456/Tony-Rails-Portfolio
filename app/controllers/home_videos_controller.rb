class HomeVideosController < ApplicationController
  before_action :set_home_video, only: %i[ show edit update destroy ]
  before_action :admin_only

  # GET /home_videos or /home_videos.json
  def index
    @home_videos = HomeVideo.all
  end

  # GET /home_videos/new
  def new
    @home_video = HomeVideo.new
  end

  # POST /home_videos or /home_videos.json
  def create
    @home_video = HomeVideo.new(home_video_params)

    respond_to do |format|
      if @home_video.save
        format.html { redirect_to home_videos_path, notice: "Home video was successfully created." }
        format.json { render :show, status: :created, location: @home_video }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @home_video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /home_videos/1 or /home_videos/1.json
  def destroy
    @home_video.destroy

    respond_to do |format|
      format.html { redirect_to home_videos_url, notice: "Home video was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_home_video
      @home_video = HomeVideo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def home_video_params
      params.require(:home_video).permit(:video)
    end
end
