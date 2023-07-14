class HomeVideo < ApplicationRecord
    has_one_attached :video

    def get_type
        if video.content_type == 'video/quicktime'
            return 'video/mp4'
        end
        return this.video.content_type
    end
end
