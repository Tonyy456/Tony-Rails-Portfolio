require 'strava-ruby-client'
class StravaController < ApplicationController
    before_action :admin_only

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

    # GET Make request for last 100 runs
    def recent
        strava_client = get_strava_client
        if(strava_client)
            @recent_activities = get_activities(strava_client, 100)
            cutoff_date = Run.order(date: :desc).first.date

            # Get only runs past latest run date.
            filtered_activities = @recent_activities.select do |activity|
                date = activity[:date].to_date
                date > Date.new(2023, 6, 1)
            end

            combined_activities = {}
            filtered_activities.each do |entry|
                date = entry[:date].to_date
                distance = entry[:distance]   
                if combined_activities[date]
                    combined_activities[date][:distance] += distance
                    puts combined_activities[date][:distance]
                else
                    puts "oh"
                    combined_activities[date] = {date: date, distance: distance}
                end
            end
            combined_activities = combined_activities.values

            combined_activities.each do |act|
                puts act
                match = nil
                match = Run.where(date: act[:date]).first
                if !match
                    Run.create(act)
                end
            end
            redirect_to runlog_path
        else
            render plain: "Failed"
        end
    end

    # GET Authenticate. Admin only
    def oauth
        admin_only
        client = get_client
        redirect_url = client.authorize_url(
            redirect_uri: "https://www.antdev.cc/runlog/callback",
            approval_prompt: 'force',
            response_type: 'code',
            scope: 'activity:read_all',
            state: 'magic'
        )
        puts '########'
        puts request.base_url + '/runlog/callback'
        puts OpenSSL::OPENSSL_VERSION

        redirect_to redirect_url, allow_other_host: true
    end

    # GET callback after oauth
    def callback
        admin_only
        client = get_client
        # maybe update production v developement to set callback url
        # https vs http might be important
        puts params[:code]
        begin 
            response = client.oauth_token(code: params[:code])
        rescue => e
            redirect_to root_path, alert: e.message and return
        end
        set_tokens(response)
        redirect_to root_path, notice: 'Tokens Generated Squirt'
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

        if current_user
            puts 'Set this'
            current_user.refresh_token_strava = response.refresh_token
            current_user.access_token_strava = response.access_token
            current_user.expires_at_strava = response.expires_at.to_datetime.in_time_zone('Eastern Time (US & Canada)')
            current_user.save
        end
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
  end
  
  
  