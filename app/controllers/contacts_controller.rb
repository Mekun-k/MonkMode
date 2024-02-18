class ContactsController < ApplicationController

  def new
    @contact = Contact.new
  end

  def confirm
    @contact = Contact.new(contact_params)
    if @contact.invalid?
      flash[:error] = "「お名前」と「メッセージ」を入力してください"
      render :new
    end
  end

  def back
    @contact = Contact.new(contact_params)
    render :new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactMailer.send_mail(@contact).deliver_now
      flash[:notice] = "お問い合わせメールの送信が完了しました。"
      if user_signed_in?
        redirect_to profile_path(current_user)
      else
        redirect_to root_path
      end
    else
      render :new
    end
  end

  private

  def contact_params
    params.require(:contact)
          .permit(:email,
                  :name,
                  :subject,
                  :message
                 )
  end
end

