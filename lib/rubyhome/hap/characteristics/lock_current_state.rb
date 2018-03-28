# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class LockCurrentState < Characteristic
      def self.uuid
        "0000001D-0000-1000-8000-0026BB765291"
      end

      def self.name
        :lock_current_state
      end

      def self.format
        "uint8"
      end

      def constraints
        {"ValidValues"=>{"0"=>"Unsecured", "1"=>"Secured", "2"=>"Jammed", "3"=>"Unknown"}}
      end

      def description
        "Lock Current State"
      end

      def permissions
        ["securedRead"]
      end

      def properties
        ["read", "cnotify", "uncnotify"]
      end

      def unit
        nil
      end
    end
  end
end