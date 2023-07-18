module StravaHelper
    def get_weeks_and_tabel(year)
        year_array = generate_weeks_for_year(year)
        labels = month_tabel_span(year_array)
        yield year_array, labels
    end
    def get_day(year_array, weeki, dayi)
        day = year_array[weeki][dayi]
        runs = Run.where(date: day)
        run = nil
        if(runs.length == 1)
            run = runs[0]
        elsif(runs.length > 1)
            run = runs[0]
        end
        yield day, run
    end
    def get_date_str(day)
        day.strftime('%A, %m/%d') 
    end
    def get_date(day)
        day.strftime('%Y-%m-%d') 
    end
    def get_color_str(run)
        if (run == nil)
            return "rgb(0,0,0)"
        end
        distance = run.distance.to_f
        start_value = 255.0
        end_value = 40.0
        max_distance = 10.0
        min_distance = 0.0
        if(distance > max_distance)
            return "rgb(0,255, 200)"
        end
        time = (max_distance - distance) / (max_distance - min_distance) 
        puts (time * 100)
        clamped_time = time.clamp(0, 1)
        interpolated_value = start_value + (end_value - start_value) * clamped_time
        "rgb(0,#{interpolated_value},0)"
    end
    def month_tabel_span(year_array)
        month_placements = []
        week_lengths = year_array.length
        current_month = 1;
        current_length = 0;
        year_array.each do |week|
            week.each do |day|
                if day == nil
                    next
                end
                if(day.month > current_month)
                    month_placements << current_length
                    current_month = current_month + 1
                    current_length = 0
                    break
                end
            end
            current_length = current_length + 1
        end
        month_placements << current_length # get december added on
        month_placements
    end
    def generate_weeks_for_year(year)
        start_date = Date.new(year, 1, 1)
        end_date = Date.new(year, 12, 31)     
        weeks = []
        week_start = start_date
        week_end = week_start.end_of_week(:sunday)     
        while week_start <= end_date
          week_range = (week_start..week_end).to_a
          if week_end.year != year
            week_range = week_range.reverse.drop_while { |date| date.year != year }.reverse
            week_range = week_range + Array.new(7 - week_range.length, nil) # pad to length 7 with nil
          end
          week_range = Array.new(7 - week_range.length, nil) + week_range
          weeks << week_range.map { |date| date ? date : nil }
          week_start = week_end + 1.day
          week_end = week_start + 6.day
        end   
        weeks
      end
end
