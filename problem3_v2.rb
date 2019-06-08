# Using composition and isolating code
class ApplicationMailer < ActionMailer::Base
  private

  def set_smtp(settings)
    puts settings
    # Change mail settings by below code
    # mail.delivery_method.settings.merge!(settings)
  end
end

# Separating what change from things stay the same
module SmtpSettings
  class << self
    def user_settings
      {
          :user_name=>"UserMailer@gmail.com"
      }
    end

    def post_settings
      {
          :user_name=>"PostMailer@gmail.com"
      }
    end

    def notification_settings
      {
          :user_name=>"NotificationMailer@gmail.com"
      }
    end
  end
end

# Dependency Inject on method
class UserMailer < ApplicationMailer
  def send(settings = SmtpSettings.user_settings)
    set_smtp settings
    # doing your stuffs here
  end
end

class PostMailer < ApplicationMailer
  def send(settings = SmtpSettings.post_settings)
    set_smtp settings
  end
end

class NotificationMailer < ApplicationMailer
  def send(settings = SmtpSettings.notification_settings)
    set_smtp settings
  end
end
