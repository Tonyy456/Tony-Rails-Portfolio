module ProjectsHelper

    def get_tag_colors
        pairs = [
            ["200,100,100", "0,0,0"],
            ["0,200,100", "0,0,0"],
            ["200,200,0", "0,0,0"],
        ]
        pair = pairs.sample
        background_color = pair[0]
        text_color = pair[1]
        { text: text_color, background: background_color }
    end
end
