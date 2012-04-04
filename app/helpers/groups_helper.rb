module GroupsHelper
  def invitation_url(invit)
    confirm_join_group_url invit.group, activation_code: invit.activation_code
  end
end
