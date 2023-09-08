class TagsController < ApplicationController
    before_action :admin_only

    def index
      @tags = Tag.all
      @tags = @tags.sort_by{|item| item.projects.count }.reverse
    end

    def show
      if params.include?("id")
        @tag = Tag.find(params[:id])
      else
        redirect_to root_path, alert: "Id not included in path, report this error to website manager"
      end
    end

    def edit
      if params.include?("id")
        @tag = Tag.find(params[:id])
        @current = @tag.projects
        @not_in = Project.all.reject do |project|
          @current.include?(project)
        end
      else
        redirect_to root_path, alert: "Id not included in path, report this error to website manager"
      end
    end

    def update
      tag_id = params[:id]
      tag = Tag.find(tag_id)
      if params.include?("add_projects")
        project_ids = params[:add_projects]
        project_ids.each do |item|
          id = item.strip
          if id.length >= 1
            project = Project.find(id)
            # add tag to project
            if !project.tags.include?(tag)
              project.tags << tag
            end
          end
        end
      end
      if params.include?("remove_projects")
        project_ids = params[:remove_projects]
        project_ids.each do |item|
          id = item.strip
          if id.length >= 1
            project = Project.find(id)
            # remove tag from project
            project.tags.delete(tag)
          end
        end
      end
      redirect_to tag_edit_path(tag_id)
    end

    def destroy
      tag_id = params[:id]
      tag = Tag.find(tag_id)
      tag.destroy
      redirect_to tag_manager, notice: "destroyed #{tag.name}"
    end
  end
  
  
  