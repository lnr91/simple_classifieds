
ActionMailer::Base.smtp_settings = {
    :address => 'smtp.gmail.com',
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true,
    :user_name => 'droidreddyhyd@gmail.com',
    :password => 'droidpass'

}
ActionMailer::Base.default_url_options[:host] = "localhost:3000"
