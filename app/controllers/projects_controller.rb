class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy ]
  before_action :admin_only, except: %i[show]

  # GET /projects or /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1 or /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @current_tags = ""
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
    @current_tags = ""
    count = @project.tags.count
    @project.tags.each_with_index do |tag, index|
      @current_tags += (index < count - 1 ? "#{tag.name}," : "#{tag.name}")
      end
  end

  # POST /projects or /projects.json
  def create
    @project = Project.new(project_params)

    tags = params[:project][:tags_to_use]
    @project.tags << tags.split(',').map { |tag_name| Tag.find_or_create_by(name: tag_name.strip.upcase) }

    ActiveRecord::Base.connection_pool.with_connection do
      respond_to do |format|
        if @project.save
          format.html { redirect_to project_url(@project), notice: "project was successfully created." }
          format.json { render :show, status: :created, location: @project }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    end 
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update

    tags = params[:project][:tags_to_use]
    remove_image = params[:project][:remove_image]

    @project.tags.clear
    @project.tags << tags.split(',').map { |tag_name| Tag.find_or_create_by(name: tag_name.strip.upcase) }
    # remove unneccesary tags. no associated projects
    Tag.includes(:projects).where(projects: { id: nil }).destroy_all

    if remove_image == '1'
      @project.image = nil
    end
    


    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to project_url(@project), notice: "project was successfully updated." }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.destroy
    # remove unneccesary tags. no associated projects
    Tag.includes(:projects).where(projects: { id: nil }).destroy_all
    respond_to do |format|
      format.html { redirect_to projects_url, notice: "project was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:title, :image, :body, :use_link, :page, :description, :started, :completed, :teamsize, :time_taken, :work_taken, :featured, :is_completed, :github, :irrelevant) #pictures: [])
    end
end
