module EventsHelper
  def date_picker(name, date)
    date = date.nil? ? Time.now : date 
    date_str = date.strftime("%F")
    picker_class = 'datepicker'

    label_tag(t(name)) + text_field_tag(name, date_str, :class => picker_class)
  end
end
