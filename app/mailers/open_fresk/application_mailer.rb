module OpenFresk
  class ApplicationMailer < ActionMailer::Base
    default from: "from@example.com"
    layout "open_fresk/mailer"
  end
end
