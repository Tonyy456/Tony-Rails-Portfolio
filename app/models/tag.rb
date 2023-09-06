class Tag < ApplicationRecord

    has_many :project_tags, dependent: :destroy
    has_many :projects, through: :project_tags  

    def title
        self.name.strip.gsub('!','').upcase
    end
end
