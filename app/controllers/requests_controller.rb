class RequestsController < ApplicationController
  def new
  end

  def show
    @request = Request.find_by id: params[:id]
  end

  def create
    if Request.find_by email: params[:request][:email].downcase
      flash.now[:danger] = {title: 'Error!', message: " There's already an active request associated with this email"}
    elsif User.find_by email: params[:request][:email].downcase
      flash.now[:danger] = {title: 'Error!', message: " There's already a user associated with this email"}
    else
      validate_request = Request.new name: params[:request][:name], email: params[:request][:email], institution: params[:request][:institution], comments: params[:request][:comments]
      if validate_request.valid?
        if validate_request.save validate: false
          flash.now[:success] = {title: 'Success!', message: " Submitted request"}
        else
          flash.now[:danger] = {title: 'Error!', message: ' Failed to submit request, please try again later'}
        end
      else
        flash.now[:danger] = {title: 'Error!', message: " #{validate_request.errors.full_messages.to_sentence}"}
      end
    end
    render turbo_stream: turbo_stream.replace("flash_alert", partial: "partials/flash", locals: { flash: flash })
  end

  def reject
    email = Request.find_by(id: params[:id]).email
    Request.find_by(id: params[:id]).destroy
    render 'reject', locals: { deleted_email: email }
  end

  def accept
    r = Request.find_by id: params[:id]
    temp_password = User.new_token.slice(0,12) + 'Ab_1'
    new_user = User.new name: r.name, email: r.email, password: temp_password, password_confirmation: temp_password, admin: false, instructor: true, student: false, approver: false
    new_user.temp_password = temp_password
    if new_user.valid?
      if new_user.save
        if new_user.send_activation_email
          r.destroy
          render 'accept', locals: { email: r.email }
        else
          render 'failed_save', locals: { email: r.email }
        end
      else
        render 'failed_save', locals: { email: r.email }
      end
    else
      render 'failed_save', locals: { email: "#{r.email}: #{new_user.errors.full_messages.to_sentence}:" }
    end
  end
end
