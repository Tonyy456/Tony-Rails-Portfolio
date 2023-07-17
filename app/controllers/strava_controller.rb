class StravaController < ApplicationController
    # before_action :admin_only, except: %i[index]

    # GET RUN LOG
    def index
        @days_2023 = generate_weeks_for_year(1985)
        @month_size_2023 = month_tabel_span(@days_2023)
    end

    # GET Make request for last 100 runs
    def recent
        strava_client = get_strava_client
        if(strava_client)
            @recent_activities = get_activities(strava_client, 100)
        end
    end

    # GET Authenticate. Admin only
    def oauth
        admin_only
        client = get_client
        redirect_url = client.authorize_url(
            redirect_uri: request.base_url + '/runlog/callback',
            approval_prompt: 'force',
            response_type: 'code',
            scope: 'activity:read_all',
            state: 'magic'
        )
        redirect_to redirect_url, allow_other_host: true
    end

    # GET callback after oauth
    def callback
        admin_only
        client = get_client
        response = client.oauth_token(grant_type: 'authorization_code', code: params[:code])
        set_tokens(response)
        redirect_to runlog_strava_recent_path
    end

    private 
    def mytime(time)
        tmp = time
        if(tmp.is_a? String)
            tmp = tmp.to_datetime
        end
        time.in_time_zone('Eastern Time (US & Canada)')
    end

    def get_activities(strava_client, count)
        activities = []    
        strava_client.athlete_activities(per_page: 10) do |activity|
            activities << { 
                date: mytime(activity.start_date),
                distance: (activity.distance * 0.0006213712).round(2)
            }
            break if activities.length >= count
        end
        activities.sort_by { |activity| activity[:date] }.reverse
    end

    def access_token_expired?
        mytime(session[:access_expiration]).to_i < mytime(Time.now).to_i
    end

    def set_tokens(response)
        session[:access_token] = response.access_token
        session[:refresh_token] = response.refresh_token
        session[:access_expiration] = response.expires_at
    end

    def get_client
        Strava::OAuth::Client.new( client_id: ENV['STRAVA_ID'], client_secret: ENV['STRAVA_CLIENT_SECRET'])
    end

    # returns false is failed to get client
    def get_strava_client(just_authenticate = true)
        client = get_client

        # check if tokens have been generated at all
        if(!session.key?(:access_token) || !session.key?(:refresh_token) || !session.key?(:access_expiration))
            return false
        end

        # check if new tokens are needed, might be able to fail not sure.
        if(access_token_expired?)
            response = client.oauth_token(grant_type: 'refresh_token', refresh_token: session[:refresh_token])    
            set_tokens(response)
        end

        # if all is well, get strava client. must be authenticated by now
        strava_client = Strava::Api::Client.new(access_token: session[:access_token])
        return strava_client
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
        # puts '============='
        # puts week_start.strftime('%A')
        # puts week_end.strftime('%A')

      
        while week_start <= end_date
          week_range = (week_start..week_end).to_a

          if week_end.year != year
            week_range = week_range.reverse.drop_while { |date| date.year != year }.reverse
            week_range = week_range + Array.new(7 - week_range.length, nil) # pad to length 7 with nil
          end
          week_range = Array.new(7 - week_range.length, nil) + week_range
          #weeks << week_range.map { |date| date.strftime('%a: %Y-%m-%d') }
          weeks << week_range.map { |date| date ? date : nil }

      
          week_start = week_end + 1.day
          week_end = week_start + 6.day
        end
      
        weeks
      end
  end
  
  
  