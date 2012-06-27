require "manning-docbook-validator/version"
require "manning-docbook-validator/error"
require "nokogiri"

module Manning
  module Docbook
    class Validator
      attr_accessor :file, :document, :errors

      def initialize(path)
        @errors = []
        @file = File.read(path)
        @document = Nokogiri::XML(@file)
      end

      def validate!
        check_for_duplicate_ids!
        check_line_lengths!
        self
      end

      private

      def check_for_duplicate_ids!
        ids = {}
        document.css("*[id]").each do |el|
          id = el[:id]
          line = el.line
          if ids[id]
            errors << Error.new("Duplicate id located on line ##{line}: #{id}. First seen on line ##{ids[id]}.")
          else
            ids[el[:id]] = el.line
          end
        end
      end

      def check_line_lengths!
        document.css("programlisting").each do |el|
          parent = el.parent
          lines = el.text.split("\n")
          lines.each_with_index do |line, i|
            if line.length > 72
              errors << Error.new("Code on line #{i+1} of #{parent.name}##{parent[:id]} is too long. Line limit is 72 characters.")
            end
          end
        end
      end
    end
  end
end
