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
  end
end
