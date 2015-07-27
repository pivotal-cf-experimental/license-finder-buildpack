require 'thor'

module LicenseFinder
  module CLI
    class Base < Thor
      class_option :project_path, desc: "Path to the project. Defaults to current working directory."
      class_option :decisions_file, desc: "Where decisions are saved. Defaults to doc/dependency_decisions.yml."

      no_commands do
        def decisions
          license_finder.decisions
        end
      end

      private

      def license_finder
        @lf ||= LicenseFinder::Core.new(license_finder_config)
      end

      def license_finder_config
        result = extract_options(:project_path, :decisions_file, :gradle_command, :rebar_command, :rebar_deps_dir)
        result[:logger] = logger_config
        result
      end

      def logger_config
        @logger_config ||= extract_options(:quiet, :debug)
      end

      def say_each(coll)
        if coll.any?
          coll.each do |item|
            say(block_given? ? yield(item) : item)
          end
        else
          say '(none)'
        end
      end

      def assert_some(things)
        unless things.any?
          raise ArgumentError, "wrong number of arguments (0 for 1+)", caller
        end
      end

      def extract_options(*keys)
        result = {}
        keys.each do |key|
          result[key.to_sym] = options[key.to_s] if options.has_key? key.to_s
        end
        result
      end
    end
  end
end

