class PortfolioController < ApplicationController
  before_action :clean_up_blobs, only: [:index]

  def tab_filter_hash
    tab_filter = {
      "Software Engineering" => ["SWE", "Software"],
      "Game Dev" => ["Game Dev"],
    }
  end

  def index
    clean_up_blobs
    @projects = Project.all
    tab_filter = tab_filter_hash

    # check if there is a tab to filter for
    if params.include?("tab")
      tab_value = params[:tab]
      tag_names = tab_filter[tab_value].map{ |tag| tag.upcase } # tags should be all caps
      filtered_projects = @projects.includes(:tags).select do |project|
        project.tags.any? { |tag| tag_names.include?(tag.name.gsub('!', '')) }
      end
      @projects = filtered_projects
    end

    # check if there is a filter
    if params.include?("filter_in")
      tag_names = params[:filter_in]
      tag_names = [tag_names] if !tag_names.is_a?(Array)
      tag_names = tag_names.map{ |item| item.upcase } 
      filtered_projects = @projects.includes(:tags).select do |project|
        project.tags.any? { |tag| tag_names.include?(tag.name.gsub('!', '')) }
      end
      @projects = filtered_projects
    end

    if params.include?("filter_out")
      tag_names = params[:filter_out]
      tag_names = [tag_names] if !tag_names.is_a?(Array)
      tag_names = tag_names.map{ |item| item.upcase } 
      filtered_projects = @projects.includes(:tags).reject do |project|
        project.tags.any? { |tag| tag_names.include?(tag.name.gsub('!','')) }
      end
      @projects = filtered_projects
    end


    # check if there is a sort
    # sorted_people = people.sort_by { |person| [person.age, -person.name] }
    # Started, Completed, Biggest Team, Smallest Team, Time Taken, Most Work, Least Work
    if params.include?("sort")
      sort_by = params[:sort].strip
      case sort_by
      when "Started"
        @projects = @projects.sort_by { |project| project.started }
      when "Completed"
        @projects = @projects.sort_by { |project| project.completed }
      when "Biggest Team"
        @projects = @projects.sort_by { |project| project.teamsize }.reverse
      when "Smallest Team"
        @projects = @projects.sort_by { |project| project.teamsize }
      when "Time Taken"
        @projects = @projects.sort_by { |project| project.time_taken }.reverse
      when "Most Work"
        @projects = @projects.sort_by { |project| project.work_taken }
      when "Least Work"
        @projects = @projects.sort_by { |project| project.work_taken }
      else
        # do nothing
      end
    end
  end
end
