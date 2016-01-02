class UpdateMailer < ActionMailer::Base
  default  to: Proc.new { User.pluck(:email) },
           from: "update@localhost"

  def notification_email
    mail(subject: 'New currency rates are available')
  end
end