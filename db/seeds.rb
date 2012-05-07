# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
StringType = ConfigurationType.create({ name: 'String', default: '', helper_method: 'text_configuration_field' })

IntegerType = ConfigurationType.create({ name: 'Integer', default: '0', helper_method: 'text_configuration_field' })

DateType = ConfigurationType.create({ name: 'Date', default: 'CURRENT_TIMESTAMP', helper_method: 'date_configuration_field' })

CollectionType = ConfigurationType.create({ name: 'Collection', default: '', helper_method: 'collection_configuration_field' })

Configuration.create([
  { 
    name: 'events.notification_interval',
    label_text: 'Days to notify',
    description: 'How early you want to be notified before event occurs (days)',
    configuration_type_id: IntegerType.id,
    default: 2
  }
])
