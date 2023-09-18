class Tag < ApplicationRecord

    has_many :project_tags, dependent: :destroy
    has_many :projects, through: :project_tags  

    def title
        self.name.strip.upcase
    end
    # def self.my_create(name,)
    #     # Custom logic to create a tag here
    #     # For example, you can create a tag with some additional attributes:
    #     new_tag = self.new
    #     new_tag.name = params[:name]
    #     new_tag.description = params[:description]
    #     new_tag.save
    #     new_tag
    #   end
end
