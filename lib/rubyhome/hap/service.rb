Dir[File.dirname(__FILE__) + '/services/*.rb'].each { |file| require file }
require_relative 'characteristic'

module Rubyhome
  class Service
    def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end

    def self.required_characteristics
      required_characteristic_uuids.map do |characteristic_uuid|
        Rubyhome::Characteristic::FROM_UUID[characteristic_uuid]
      end
    end

    def self.optional_characteristics
      optional_characteristic_uuids.map do |characteristic_uuid|
        Rubyhome::Characteristic::FROM_UUID[characteristic_uuid]
      end
    end

    def initialize(accessory: , primary: false, hidden: false)
      @accessory = accessory
      @primary = primary
      @hidden = hidden
      @characteristics = []
    end

    attr_reader :accessory, :characteristics, :primary, :hidden
    attr_accessor :instance_id

    def uuid
      self.class.uuid
    end

    def characteristic(characteristic_name)
      characteristics.find do |characteristic|
        characteristic.name == characteristic_name
      end
    end

    def save
      IdentifierCache.add_accessory(accessory)
      IdentifierCache.add_service(self)
    end

    def inspect
      {
        primary: primary,
        hidden: hidden,
        characteristics: characteristics
      }
    end
  end
end