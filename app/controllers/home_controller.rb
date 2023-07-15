class HomeController < ApplicationController
  def index
    #flash[:notice] = 'Bro what are you doing?!?!'
    @banner_videos = HomeVideo.all
  end

  def admin
    admin_only
  end

  # get fileupload
  def fileupload
    admin_only
    @uploaded_images = params[:uploaded_images] || []
  end

  # post

  def upload
    admin_only
    @uploaded_images = []
    if params[:folder_upload].present?
      require 'zip'
      Zip::File.open(params[:folder_upload].path) do |zip_file|
        zip_file.each do |f|
          if image_file?(f)
            @uploaded_images << f.name # Add the extracted image path to the list
          end
        end
      end
    end
    redirect_to fileupload_path(uploaded_images: @uploaded_images)
  end

  def image_file?(file)
    image_extensions = ['.jpg', '.jpeg', '.png', '.gif']
    extension = File.extname(file.name).downcase
    image_extensions.include?(extension)
  end
end

# FileUtils.mkdir_p(File.dirname(f_path))
# zip_file.extract(f, f_path) unless File.exist?(f_path)
