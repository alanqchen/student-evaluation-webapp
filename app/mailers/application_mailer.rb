class ApplicationMailer < ActionMailer::Base
  default from: "noreply@evaluate-me-prod.herokuapp.com"
  layout "mailer"
end
