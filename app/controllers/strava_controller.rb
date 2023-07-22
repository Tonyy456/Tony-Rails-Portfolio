require 'strava-ruby-client'
class StravaController < ApplicationController
    before_action :admin_only

    require 'httparty'

    # Replace these values with your Strava application credentials
    CLIENT_ID = ENV['STRAVA_ID']
    CLIENT_SECRET = ENV['STRAVA_CLIENT_SECRET']
    REDIRECT_URI = ENV['STRAVA_REDIRECT_URI']
  
    def authorize
      redirect_to "https://www.strava.com/oauth/authorize?client_id=#{CLIENT_ID}&response_type=code&redirect_uri=#{REDIRECT_URI}&scope=activity:read_all", allow_other_host: true
    end
  
    def callback
      code = params[:code]
      access_token = exchange_code_for_token(code)
      if access_token
        activity = get_first_activity(access_token)
        render json: {response: activity, accesss_token_response: access_token}
      else
        render json: { error: 'Failed to get access token from Strava' }, status: :unprocessable_entity
      end
    end
  
    private
  
    def exchange_code_for_token(code)
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
  
    def get_first_activity(access_token)
        puts access_token
      response = HTTParty.get(
        'https://www.strava.com/api/v3/athlete/activities',
        headers: { "Authorization" => "Bearer #{access_token}" }
      )
      activities = JSON.parse(response.body)
      if response.success?
        puts '########################### Well it succeeded!'
        puts activities.present?
      else
        puts '########################### I hate this sh*t'
        puts activities.present?
        return response
      end
      activities.first if response.success? && activities.present?
    end

    # ##############################################################

    # Admin Login
    def index
        
    end

    # GET redirect fun redirect to this and it will do all the work.
    def auto_logger
        client = Strava::OAuth::Client.new( client_id: ENV['STRAVA_ID'], client_secret: ENV['STRAVA_CLIENT_SECRET'])
        if(!current_user)
            redirect_to root_path, alert: "No current user" and return
        end
        if(current_user.refresh_token_strava == nil || current_user.access_token_strava == nil || current_user.expires_at_strava == nil)
            redirect_to root_path, alert: "Didnt autolog. Tokens empty." and return
        end
        puts current_user.expires_at_strava == nil
        if(current_user.expires_at_strava < DateTime.current)
            response = client.oauth_token(grant_type: 'refresh_token', refresh_token: current_user.refresh_token_strava)    
            set_tokens(response)
        end
        strava_client = Strava::Api::Client.new(access_token: current_user.access_token_strava)

        toadd = {}
        strava_client.athlete_activities.each do |activity|
            datetime = activity.start_date.to_datetime
            datetime_est = datetime.in_time_zone('Eastern Time (US & Canada)')
            date = datetime.to_date
            date_est = datetime_est.to_date
            puts date

            distance = (activity.distance * 0.0006213712)

            next if Run.exists?(date: date_est)
            if toadd[date_est]
                toadd[date_est][:distance] += distance
            else
                toadd[date_est] = {date: date_est, distance: distance}
            end
            # toadd << {date: date, distance: distance}
        end
        toadd = toadd.values

        #render json: toadd
        toadd.each do |item|
            #puts item
            Run.create(item)
        end

        redirect_to runlog_path(autologged: "logged"), notice: "Logged #{toadd.length} values to the run log!"
    end

    private 
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
  
  
  