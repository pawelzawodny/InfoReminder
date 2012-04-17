require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "owner_can_manage_own_event" do
    private_group = groups(:private_group)
    owner = private_group.user
    own_event = private_group.events.create(user_id: owner.id) 
    
    assert(own_event.can_write?(owner), "Owner can't update his event")
    assert(own_event.can_read?(owner), "Owner can't read his own event")
    assert(own_event.can_delete?(owner), "Owner can't delete his own event")
  end

  test "prevent_adding_event_without_date" do
    public_group = groups(:public_group)
    owner = public_group.user

    event_without_date = public_group.events.new( 
      { 
        title: "some title",
        user_id: owner.id
      }
    )

    assert(!event_without_date.save, "Can save event without date")

  end

  test "prevent_adding_event_without_title" do
    public_group = groups(:public_group)
    owner = public_group.user

    event_without_title = public_group.events.new( 
      { 
        date: Time.now, 
        user_id: owner.id
      }
    )

    assert(!event_without_title.save, "Can save event without title")
  end

  test "find_all_user_events_within_period" do
    prepare_period_test

    assert_not_nil(
      @jan_events.find { |e| e.id == @jan_event.id},
      "January events doesn't include first january event")

    assert_not_nil(
      @jan_to_march.find { |e| e.id == @jan_event.id},
      "January to march events doesn't include first january event")

    assert_not_nil(
      @jan_to_march.find { |e| e.id == @feb_event.id }, 
      "February event not found in jan-march period")
  end

  test "events_not_matching_period_are_not_found" do
    prepare_period_test

    assert_nil(
      @jan_events.find { |e| e.id == @feb_event.id }, 
      "February event found in january period")

  end

  test "boundary_events_are_found_within_period" do
    prepare_period_test

    assert_not_nil(
      @jan_events.find { |e| e.id == @last_january_event.id },
      "31st january event not found within january period")
  end

  test "find_events_limited_by_one_date" do
    prepare_period_test


    any_event_missing_in_nil_to_march = @jan_to_march.any? do |e|
      !@nil_to_march.one? { |e2| e2.id == e.id }
    end

    any_event_missing_in_jan_to_nil = @jan_to_march.any? do |e|
      !@jan_to_nil.one? { |e2| e2.id == e.id }
    end

    assert(
      !any_event_missing_in_nil_to_march,
      "At least one event is missing in nil to march period"
    )

    assert(
      !any_event_missing_in_jan_to_nil,
      "At least one event is missing in jan to march period"
    )
  end

  private

  def prepare_period_test
    @user_one = users(:one)
    @user_group = @user_one.groups.create({ name: "test group", description: "description", public: false })

    @jan_event = @user_group.events.create({ 
      title: "event one", 
      description: "description", 
      date: Time.new(2012,01,01) 
    })

    @last_january_event = @user_group.events.create({
      title: "last jan",
      description: "last jan",
      date: Time.new(2012,01,31)
    })

    @feb_event = @user_group.events.create({ 
      title: "february", 
      description: "description", 
      date: Time.new(2012,02,01)
    })

    @jan_events = Event.find_user_events_within_period(@user_one, 
                                         Time.new(2012,01,01),
                                         Time.new(2012,01,31))
    @jan_to_march = Event.find_user_events_within_period(@user_one, 
                                         Time.new(2012,01,01),
                                         Time.new(2012,03,31))
    @nil_to_march = Event.find_user_events_within_period(@user_one, nil, Time.new(2012,03,31))

    @jan_to_nil = Event.find_user_events_within_period(@user_one, Time.new(2012, 01, 01), nil)
  end
end
