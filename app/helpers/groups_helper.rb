module GroupsHelper
  def invitation_url(invit)
    confirm_join_group_url invit.group, activation_code: invit.activation_code
  end

  def group_picker(groups, default)
    collection_select(:group, 
      :id, 
      groups, 
      :id, 
      :name, 
      { 
        include_blank: "All groups",
        default: default
      }) 
  end
end
