module LicenseFinder
  class Report
    def self.of(dependencies, options)
      new(dependencies, options).to_s
    end

    def initialize(dependencies, options)
      @dependencies = dependencies
      @project_name = options[:project_name]
    end

    private
    attr_reader :dependencies, :project_name

    def sorted_dependencies
      dependencies.sort_by(&:name)
    end
  end
end

require 'license_finder/reports/erb_report'

require 'license_finder/reports/csv_report'
require 'license_finder/reports/text_report'
require 'license_finder/reports/html_report'
require 'license_finder/reports/markdown_report'
