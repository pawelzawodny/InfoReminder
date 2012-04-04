require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'join_public_group' do
    group = groups(:public_group)
    user = users(:two)

    assert(! group.is_member?(user), "User is already member of public group")
    assert(group.can_join?(user), "User can't join public group")

    assert(group.add_member(user), "Failed to add member to public group")
    assert(group.is_member?(user), "User is not member of public group")
    assert_not_nil(group.membership(user), "Can't find membership object")
  end

  test 'leave_group' do
    group = groups(:public_group)
    user = users(:two) 

    assert(group.add_member(user), "Failed to add member to public group")
    assert(group.is_member?(user), "User is not member of public group")
    assert(group.can_leave?(user), "User can't leave group")
    assert_not_nil(group.membership(user), "User membership object can't be found")
    assert(group.membership(user).destroy, "Can't remove membership")
    assert(!group.is_member?(user), "User is still member of a group")
    assert_nil(group.membership(user), "User membership object still exists")
  end

  test 'create_group_by_user' do
    user = users(:one)
    group = user.groups.new({ name: 'group name', description: 'description', public: false })
    assert_not_nil(group, "Can't instantiate group object")
    assert(group.save, "Can't save user group")
    assert(!group.is_member(user), "User is just a member of his own group")
    assert(group.is_owner(user), "User is not owner of his group")
    assert(group.can_read?(user), "User can read in his own group")
    assert(group.can_write?(user), "User can't write in his own group")
    assert(group.can_manage?(user), "User can't manage his own group")
    assert_nil(group.membership(user), "User have membership object");
  end

  test 'add_event_in_owned_group' do
    user = users(:one)
    group = user.groups.new({ name: 'group name', description: 'description', public: false })
    event = group.events.new({ title: 'event name', description: 'description', user_id: user.id })

    assert(group.save, "Can't save group")
    assert_not_nil(event, "Can't create event object") 
    assert(event.save, "Can't save event") 
  end

  test 'join_private_group_with_invitation' do
    user = users(:one)
    second_user = users(:two)
    group = user.groups.new({ name: 'group', description: 'description', public: false })
    invitation = Invitation.invite_anonymous(group, false)

    assert_not_nil(invitation, "Can't create anonymous invitation")
    assert(!group.can_join?(second_user), "User can join private group without invitation")
    assert(group.can_join?(second_user, activation_code: invitation.activation_code), "User can't join with valid activation code")
    assert(!group.can_join?(second_user, activation_code: invitation.activation_code + "_invalid"), "Can join with invalid activation code")
    assert(!group.add_member(second_user), "Can join without invitation")
    assert(!group.add_member(second_user, 
                             activation_code: invitation.activation_code + "_invalid"),
                             "Can join with invalid activation code")
    assert(!group.is_member?(second_user), "User is member despite code was invalid")
    assert(group.add_member(second_user, activation_code: invitation.activation_code), "Can't add user with valid activation code")
    assert(group.is_member?(second_user), "User is not member of group")
  end
end
