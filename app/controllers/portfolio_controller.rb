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
    params.permit(:sort, :filter_in, :filter_out, :tab, :currently_on, :completed, :irrelevant)
  end

  def index
    portfolio_params
    @projects = Project.all
    @error = false
    @error_msg = ""

    tab_filter = tab_filter_hash
    filter_boolean_parameters
    filter_for_tab
    @fi_tags = use_filter_in_tags
    @fo_tags = use_filter_out_tags
    sort_projects

    @tags = []
    @projects.each do |project|
      project.tags.each do |tag|
        if !@tags.include?(tag.name)
          if !tag.hide_in_view
            @tags << tag.name.strip.upcase
          end
        end
      end
    end
  end

  def filter_boolean_parameters
    @completed_only = params.include?("completed") && params[:completed] == 'true'
    @use_irrelevant = params.include?("irrelevant") && params[:irrelevant] == 'true'
    @currently_on = params.include?("currently_on") && params[:currently_on] == 'true'

    @projects = @projects.select { |project| project.is_completed } if @completed_only
    @projects = @projects.reject { |project| project.irrelevant } if !@use_irrelevant
    @projects = @projects.select { |project| project.completed == nil } if @currently_on
  end

  def filter_for_tab
    if params.include?("tab")
      tab_value = params[:tab]
      tag_names = tab_filter[tab_value].map{ |tag| tag.upcase.strip } # tags should be all caps
      filtered_projects = @projects.select do |project|
        project.tags.any? { |tag| tag_names.include?(tag.title) }
      end
      @projects = filtered_projects
    end
  end

  def use_filter_in_tags
    tag_names = []
    if params.include?("filter_in")
      tag_names = params[:filter_in]
      tag_names = [tag_names] if !tag_names.is_a?(Array)
      tag_names = tag_names.map{ |item| item.upcase.strip } 
      filtered_projects = @projects.select do |project|
        project.tags.any? { |tag| tag_names.include?(tag.title) }
      end
      @projects = filtered_projects
    end
    tag_names
  end

  def use_filter_out_tags
    tag_names = []
    if params.include?("filter_out")
      tag_names = params[:filter_out]
      tag_names = [tag_names] if !tag_names.is_a?(Array)
      tag_names = tag_names.map{ |item| item.upcase.strip } 
      filtered_projects = @projects.reject do |project|
        project.tags.any? { |tag| tag_names.include?(tag.title) }
      end
      filtered_projects = [filtered_projects] if !filtered_projects.is_a?(Array)
      @projects = filtered_projects
    end
    tag_names
  end

  def sort_projects
    @sort_by = ""
    if params.include?("sort")
      @sort_by = params[:sort].strip
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
          @projects = @projects.sort_by { |project| project.started || Time.zone.now - 100.years }.reverse
      end
    else
      # default sort is the most recent project
      @projects = @projects.sort_by do |project| 
        started = project.started || Time.zone.now - 100.years
        completed = project.completed || Time.zone.now - 1.month
        latest = started <= completed ? completed : started # done just in case user error
        latest
      end.reverse
    end
  end
end
