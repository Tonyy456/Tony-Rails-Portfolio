module ProjectsHelper

    def pairs = [
        [255,99,71,255,255,255],   # Tomato background with White text
        [0,0,128,255,255,255],     # Navy background with White text
        #[255,165,0, 0,0,0],         # Orange background with Black text
        [0,128,0, 255,255,255],     # Green background with White text
        [138,43,226, 255,255,255],  # BlueViolet background with White text
        [255,20,147, 255,255,255],  # DeepPink background with White text
        [70,130,180, 255,255,255],  # SteelBlue background with White text
        # [255,215,0, 0,0,0],         # Gold background with Black text
    ]
    
    
    def get_tag_colors(str, divisor = 1)
        pair = pairs[(str.hash.abs + 0) % pairs.count]
        background_color = "#{pair[0] / divisor },#{pair[1] / divisor },#{pair[2] / divisor }"
        text_color = "#{pair[3] * divisor},#{pair[4] * divisor},#{pair[5] * divisor}"
        { text: text_color, background: background_color }
    end
end
