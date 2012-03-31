class MembershipController < ApplicationController
  # Action used to confirm that user wants to join this group
  def confirm_join 
    @group = Group.find(params[:id])

    if !@group.can_join(current_user, activation_code: params[:activation_code])
      return redirect_to groups_path
    end

    respond_to do |format|
      format.html
    end
  end

  # Adds current user as a member to group (if it's public group or it has invitation)
  def join
    @group = Group.find(params[:id])

    if !@group.can_join(current_user, activation_code: params[:activation_code])
      return redirect_to groups_path
    end

    if @group.add_member(current_user, activation_code: params[:activation_code])
      @success = true
    end

    redirect_to group_events_path(@group)
  end

  # Action used to leave group
  def leave
    @group = Group.find(params[:id]) 

    if (@group.can_leave? current_user)
      membership = @group.membership(current_user)
      membership.destroy
    end

    redirect_to manage_groups_path
  end

  # Action used to invite user to group
  def invite
    user = User.where(id: params[:user_id]).first
    group = Group.find(params[:group_id])
    if group.nil?
      return redirect_to manage_groups_path
    end

    if !user.nil?
      @invitation = Invitation.invite_user(group, user)
    else
      @invitation = Invitation.invite_anonymous(group, false) 
    end

    respond_to do |format|
      format.html
    end
  end
end
