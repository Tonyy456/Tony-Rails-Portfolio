class StravaController < ApplicationController
    before_action :admin_only

    require 'httparty'

    # Replace these values with your Strava application credentials
    CLIENT_ID = ENV['STRAVA_ID']
    CLIENT_SECRET = ENV['STRAVA_CLIENT_SECRET']
    REDIRECT_URI = ENV['STRAVA_REDIRECT_URI']
  
    # Admin Login
    def index
        
    end

    # get which redirects
    def oauth
      redirect_to "https://www.strava.com/oauth/authorize?client_id=#{CLIENT_ID}&response_type=code&redirect_uri=#{REDIRECT_URI}&scope=activity:read_all", allow_other_host: true
    end
  
    # get callback
    def callback
      code = params[:code]
      access_token = token_exchange(code)
      if access_token
        activities = get_new_activities(access_token)
        if activities
          activities.each do |act|
            add_activity(act)
          end
          message = activities.length > 0 ? "retrieved #{activities.length} new runs from #{activities.first[:date]} to #{activities.last[:date]}"
                                          : "retrieved 0 runs"
          redirect_to runlog_path, notice: message
        else
          redirect_to runlog_path, alert: "failed to retrieve new runs"
        end
      else
        redirect_to runlog_path, alert: "failed to complete token exchange"
      end
    end
  
    private
  
    def token_exchange(code)
      response = HTTParty.post(
        'https://www.strava.com/oauth/token',
        body: {
          client_id: CLIENT_ID,
          client_secret: CLIENT_SECRET,
          code: code,
          grant_type: 'authorization_code'
        }
      )
      response['access_token'] if response.success?
    end

    def get_new_activities(access_token)
        after_date = Run.maximum(:date)
        after_date = Date.now - 1.years if after_date == nil
        url = "https://www.strava.com/api/v3/athlete/activities"
        headers = { "Authorization" => "Bearer #{access_token}" }   
        all_activities = []
        page = 1
        loop do
          break if page > 4
          response = HTTParty.get(url, query: { page: page }, headers: headers)
          if response.success?
            puts "recieved page"
            activities = JSON.parse(response.body)
            break if activities.empty?
            activities_after_date = activities.select { |activity| mytime(activity['start_date']).to_date > after_date } 
            break if activities_after_date.length <= 0
            distances = activities_after_date.map { |activity| process_activity(activity) }
            all_activities.concat(distances)
            page += 1
          else
            render json: { error: "Failed to fetch activities" }, status: :unprocessable_entity
            return
          end
        end
        combined_data = all_activities.group_by { |hash| hash[:date].to_date }.map do |date, hashes|
          total_distance = hashes.sum { |hash| hash[:distance] }
          { "distance": total_distance, "date": date }
        end
        
        combined_data
    end

    # Must not be duplicates or only one will be added
    def add_activity(entity)
      puts entity
      date = entity[:date]
      return if Run.exists?(date: date)
      Run.create(entity)
    end

    # processes json from strava into a hash.
    def process_activity(activity)
      # date.strftime('%m/%d/%Y')
      {distance: activity['distance'].to_f * 0.000621371, date: mytime(activity['start_date']).to_date}
    end

    def mytime(time)
        tmp = time
        if(tmp.is_a? String)
            tmp = tmp.to_datetime
        end
        time.in_time_zone('Eastern Time (US & Canada)')
    end

    def set_tokens(response)
        session[:access_token] = response.access_token
        session[:refresh_token] = response.refresh_token
        session[:access_expiration] = response.expires_at

        if current_user
            puts 'Set this'
            current_user.refresh_token_strava = response.refresh_token
            current_user.access_token_strava = response.access_token
            current_user.expires_at_strava = response.expires_at.to_datetime.in_time_zone('Eastern Time (US & Canada)')
            current_user.save
        end
    end
  end
  
  
  