class ExchangeWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily.hour_of_day(9) }

  def perform
    Exchange.get_new_rates
    UpdateMailer.notification_email.deliver_now
  end

end