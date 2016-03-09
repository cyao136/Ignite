class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if @contact.deliver
	  flash[:success] = 'Thank you for your message. We will contact you soon!'
    else
      flash[:error] = 'Oh No! An error has occured. Cannot send message at this time.'
    end
  end
end