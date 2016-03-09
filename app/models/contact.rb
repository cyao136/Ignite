class Contact < MailForm::Base
  attribute :name,      :validate => true
  attribute :email
  attribute :message
  attribute :nickname,  :captcha  => true

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      :subject => "Ignite Contact Us Reply",
      :to => "ignite.crowdfund@gmail.com",
      :from => %("#{name}")
    }
  end
end