class HomeController < ApplicationController
  def index
    #flash[:notice] = 'Bro what are you doing?!?!'
    @banner_videos = HomeVideo.all
    @projects = Project.where(featured: true)
  end

  def resume
    
  end
  def resume_as_html
    render layout: 'resume'
  end

  def show_file
    filename = params[:filename] + '.pdf'
    path = File.join(Rails.root, 'public', 'pdfs', filename)

    if File.exist?(path)
      send_file path, type: 'application/pdf', disposition: 'inline'
    else
      # Handle the case where the PDF file does not exist
      # You can render an error view or redirect as needed
      redirect_to root_path, alert: "#{path} does not exist."
    end
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
            @uploaded_images << f.name 
            # https://stackoverflow.com/questions/19754883/how-to-unzip-a-zip-file-containing-folders-and-files-in-rails-while-keeping-the
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


