class ContactMailer < ApplicationMailer

    default from: 'ajdalesandro0115@gmail.com'

    def contact_email(contact_params)
      @name = contact_params[:name]
      @email = contact_params[:email]
      @message = contact_params[:message]
  
      mail(to: 'ajdalesandro0115@gmail.com', subject: 'New Contact Form Submission') do |format|
        format.html
      end
    end
end
