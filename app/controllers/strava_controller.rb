class StravaController < ApplicationController
    # before_action :admin_only, except: %i[index]

    # GET RUN LOG
    def index
        @runs = Run.all
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
  end
  
  
  