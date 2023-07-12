class Pin < ApplicationRecord
    has_one_attached :image
    has_rich_text :body

    def image_as_thumbnail
        return unless image.content_type.in?(%w[image/jpeg image/png])
        image.variant(resize_to_limit: [300,300]).processed
    end
    def pictures_as_thumbnails
        pictures.map do |picture|
            picture.variant(resize_to_limit: [300,300]).processed
        end
    end
    def picture_as_thumbnail (pic)
        pic.variant(resize_to_limit: [100,100]).processed
    end
    def image_as_limit(limx, limy)
        return unless image.content_type.in?(%w[image/jpeg image/png])
        image.variant(resize_to_limit: [limx,limy]).processed
    end 
end
