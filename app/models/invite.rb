class Invite < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  validates :user_money, numericality: { greater_than_or_equal_to: 0 }
  after_create :send_sms

  scope :accepted, -> { where(state: 1) }

  DONTANSWERED = 0
  ACCEPT = 1
  REJECT = 2

  require 'net/http'
  require 'uri'

  def send_sms
    phone_number = user.phone_number
    text = "#{I18n.t(:hello)} #{user.name} #{event.name} #{event.date.strftime('%d.%m.%Y')}"
    uri = URI(App.sms_uri)
    res = Net::HTTP.post_form(uri,
                              api_id: App.sms_token,
                              to: phone_number,
                              text: text,
                              test: 1
    )
    if res.body.split("\n").first != '100'
      logger.error "Error! Answer:#{res.body}"
       "Error! Answer:#{res.body.split("\n").first}"
    else
      res.body.split("\n").first
    end
  end

end
