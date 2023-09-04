class ApplicationController < ActionController::Base
    before_action :set_url_states

    def set_url_states
        session[:previous_request_url] = session[:current_request_url]
        session[:current_request_url] = request.url
    end

    def clean_up_blobs
        ActiveStorage::Blob.unattached.where("active_storage_blobs.created_at > ?", 2.minutes.ago).find_each(&:purge_later)
    end

    def admin_only
        if !user_signed_in?
            redirect_to root_path, alert: "You do not have permission to do that."
            return
        end
    end
end
