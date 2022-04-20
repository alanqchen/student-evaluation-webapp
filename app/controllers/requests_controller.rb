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
          flash.now[:success] = {title: 'Success!', message: ' Submitted request'}
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
    if Request.find_by(id: params[:id])&.destroy
      render turbo_stream: [
        turbo_stream.replace("toast", partial: "partials/toast", locals: { type: "success", message: "#{email} has been rejected" }),
        turbo_stream.update("dashboardTop", template: "dashboards/manage_requests")
      ]
    else
      render turbo_stream: turbo_stream.replace("toast", partial: "partials/toast", locals: { type: "danger", message: "Failed to reject #{email}" })
    end
  end

  def accept
    r = Request.find_by id: params[:id]
    temp_password = User.new_token.slice(0,12) + 'Ab_1'
    new_user = User.new name: r.name, email: r.email, password: temp_password, password_confirmation: temp_password, admin: false, instructor: true, student: false, approver: false
    new_user.temp_password = temp_password
    if new_user.valid?
      if new_user.save
        if new_user.send_activation_email
          if r.destroy
            render turbo_stream: [
              turbo_stream.replace("toast", partial: "partials/toast", locals: { type: "success", message: "#{r.email} has been accepted" }),
              turbo_stream.update("dashboardTop", template: "dashboards/manage_requests")
            ]
          else
            render turbo_stream: turbo_stream.replace("toast", partial: "partials/toast", locals: { type: "warning", message: "Failed to destroy request for #{r.email}" })
          end
        else
          # Need all these else's since renders don't return and we can't have multiple called in a single branch
          new_user.destroy
          render turbo_stream: turbo_stream.replace("toast", partial: "partials/toast", locals: { type: "danger", message: "Failed to send email to #{r.email}" })
        end
      else
        render turbo_stream: turbo_stream.replace("toast", partial: "partials/toast", locals: { type: "danger", message: "#{r.email} was not able to be saved" })
      end
    else
      render turbo_stream: turbo_stream.replace("toast", partial: "partials/toast", locals: { type: "danger", message: "#{r.email} was not able to be saved" })
    end
  end
end
