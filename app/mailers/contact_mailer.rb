class ContactMailer < ApplicationMailer
  def send_mail(contact)
    @contact = contact
    mail to:   ENV['COMFIRMABLE_ADDRESS'], subject: '【お問い合わせ】' + @contact.message
  end
end

