class TagsController < ApplicationController
    before_action :admin_only

    def index
      @tags = Tag.all
      @tags = @tags.sort_by{|tag| [-tag.projects.count, tag.name] }
    end

    def show
      if params.include?("id")
        @tag = Tag.find(params[:id])
      else
        redirect_to root_path, alert: "Id not included in path, report this error to website manager"
      end
    end

    # GET
    def new
    end
    # POST
    def create
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
      if params.include?("hide_in_view")
        tag.hide_in_view = params[:hide_in_view]
        tag.save
      end
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
      if params.include?("title")
        change_to = params[:title].strip.gsub('.','').upcase
        if tag.name != change_to
          match = Tag.find_by(name: change_to)
          message = "Didnt rename it"
          
          if match # check if a tag already exists with such a name
            message = "Found a match, merged tags together."
            # add all projects to match, delete current tag
            tag.projects.each do |project|
              if !match.projects.include?(project)
                match.projects << project
              end
            end
            tag.projects.clear
            tag.delete

            redirect_to tag_edit_path(id: match), notice: "Merged #{tag.name} to #{match.name}" and return
          else # if not just change title and move on.
            message = "No match, just rename!"
            tag.name = change_to
            if !tag.save
              redirect_to tag_edit_path(tag_id), notice: "failed to change #{tag.name}'s name." and return
            end
          end
          redirect_to tag_edit_path(tag_id), notice: "successfully updated #{tag.name}. #{message}" and return
        end
      end
      redirect_to tag_edit_path(tag_id), notice: "successfully updated #{tag.name}"
    end

    def destroy
      tag_id = params[:id]
      tag = Tag.find(tag_id)
      tag.destroy
      redirect_to tag_manager, notice: "destroyed #{tag.name}"
    end

    def toggle_tag_hide_in_view
      tag = Tag.find(params[:id])

      
      if tag
        hide = tag.hide_in_view
        tag.hide_in_view = !hide
        if tag.save
          action = hide ? "Displayed" : "Hide"
          redirect_back(fallback_location: root_path, notice: "#{action} #{tag.title}!")
        else
          redirect_back(fallback_location: root_path, notice: "Failed on #{tag.title}!")
        end
      else
        redirect_back(fallback_location: root_path, alert: "Did not find tag #{params[:id]}!")
      end
      
    end
  end
  
  
  