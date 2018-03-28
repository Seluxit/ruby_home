# This is an automatically generated file, please do not modify

module Rubyhome
  class Characteristic
    class MotionDetected < Characteristic
      def self.uuid
        "00000022-0000-1000-8000-0026BB765291"
      end

      def self.name
        :motion_detected
      end

      def self.format
        "bool"
      end

      def constraints
        {}
      end

      def description
        "Motion Detected"
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