class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)&.authenticate params[:session][:password]
    if user
      # TODO
      flash.now[:success] = {title: 'Success!', message: ' Valid email/password combination'}
      render turbo_stream: turbo_stream.replace("flash_alert", partial: "partials/flash", locals: { flash: flash })
    else
      # TODO
      flash.now[:danger] = {title: 'Error!', message: ' Invalid email/password combination'}
      render turbo_stream: turbo_stream.replace("flash_alert", partial: "partials/flash", locals: { flash: flash })
    end
  end

  def destroy
    render 'new'
  end
end
