class ContactsController < ApplicationController
  #removed for alpha stage
  #skip_before_filter :authenticate_user!

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if @contact.deliver
	  flash[:success] = 'Thank you for your message. We will contact you soon!'
	  redirect_to contact_path
    else
      flash[:error] = 'Oh No! An error has occured. Cannot send message at this time.'
	  redirect_to contact_path
    end
  end
end
