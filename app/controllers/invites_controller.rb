class InvitesController < ApplicationController

  before_action :require_user

  def new
    @invite = Invite.new
  end

  def create
    @invite = current_user.invites.build(invite_params)

    if @invite.save
      flash[:success] = "Your invitation has been successfully sent to #{@invite.invitee_email}"
      AppMailer.delay.invite_friend(@invite, current_user.name)
      redirect_to people_path
    else
      render :new
    end
  end

  private

  def invite_params
    params[:invite].permit(:invitee_name, :invitee_email, :message)
  end

end
