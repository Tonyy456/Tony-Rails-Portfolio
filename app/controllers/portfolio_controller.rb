class PortfolioController < ApplicationController
  before_action :clean_up_blobs, only: [:index]

  def tab_filter_hash
    # What the tab filters_in for
    tab_filter = {
      "Software Engineering" => ["SWE", "Software"],
      "Game Dev" => ["Game Dev"],
    }
  end

  def portfolio_params
    params.permit(:sort, :filter_in, :filter_out, :tab, :completed => [])
  end

  def index
    portfolio_params
    @projects = Project.all
    tab_filter = tab_filter_hash

    @completed_only = false
    if params.include?("completed")
      @completed_only = params[:completed]
      if @completed_only == 'true'
        @completed_only = true
      elsif @completed_only == 'false'
        @completed_only = false
      else
        redirect_to root_path, alert: "Completed url parameter is not a boolean?!" and return 
      end
    end

    if @completed_only
      filtered_projects = @projects.select do |project|
        project.is_completed
      end
      @projects = filtered_projects
    end

    # check if there is a tab to filter for
    if params.include?("tab")
      tab_value = params[:tab]
      tag_names = tab_filter[tab_value].map{ |tag| tag.upcase } # tags should be all caps
      filtered_projects = @projects.select do |project|
        project.tags.any? { |tag| tag_names.include?(tag.title) }
      end
      @projects = filtered_projects
    end

    # check if there is a filter
    @fi_tags = []
    if params.include?("filter_in")
      tag_names = params[:filter_in]
      tag_names = [tag_names] if !tag_names.is_a?(Array)
      tag_names = tag_names.map{ |item| item.upcase.gsub('!','') } 
      @fi_tags = tag_names
      filtered_projects = @projects.select do |project|
        project.tags.any? { |tag| tag_names.include?(tag.title) }
      end
      @projects = filtered_projects
    end

    @fo_tags = []
    if params.include?("filter_out")
      tag_names = params[:filter_out]
      tag_names = [tag_names] if !tag_names.is_a?(Array)
      tag_names = tag_names.map{ |item| item.upcase.gsub('!','') } 
      @fo_tags = tag_names
      filtered_projects = @projects.reject do |project|
        project.tags.any? { |tag| tag_names.include?(tag.title) }
      end
      filtered_projects = [filtered_projects] if !filtered_projects.is_a?(Array)
      @projects = filtered_projects
    end


    # check if there is a sort
    # sorted_people = people.sort_by { |person| [person.age, -person.name] }
    # Started, Completed, Biggest Team, Smallest Team, Time Taken, Most Work, Least Work
    @sort_by = ""
    if params.include?("sort")
      @sort_by = params[:sort].strip.gsub('!','')
      case @sort_by
      when "Oldest"
        @projects = @projects.sort_by { |project| project.started || Time.zone.now + 100.years }
      when "Youngest"
        @projects = @projects.sort_by { |project| project.started || Time.zone.now - 100.years }.reverse
      when "Last Completed"
        @projects = @projects.sort_by { |project| project.completed || Time.zone.now - 100.years }.reverse
      when "Biggest Team"
        @projects = @projects.sort_by { |project| project.teamsize || -10000000 }.reverse
      when "Smallest Team"
        @projects = @projects.sort_by { |project| project.teamsize || 100000000 }
      when "Time Taken"
        @projects = @projects.sort_by { |project| project.time_taken || -10000 }.reverse
      when "Most Work"
        @projects = @projects.sort_by { |project| project.work_taken || -100000 }.reverse
      when "Least Work"
        @projects = @projects.sort_by { |project| project.work_taken || 100000000 }
      else
        # do nothing
      end
    end

    @tags = []
    @projects.each do |project|
      project.tags.each do |tag|
        if !@tags.include?(tag.name)
          @tags << tag.name
        end
      end
    end

    # ensure no funny business
    @tags = @tags.map{ |item| item.gsub('!','').strip.upcase }
    @fo_tags = @fo_tags.map{ |item| item.gsub('!','').strip.upcase }
    @fi_tags = @fi_tags.map{ |item| item.gsub('!','').strip.upcase }
  end
end
