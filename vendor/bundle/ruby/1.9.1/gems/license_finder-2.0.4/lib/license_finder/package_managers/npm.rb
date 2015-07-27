require 'json'

module LicenseFinder
  class NPM < PackageManager
    DEPENDENCY_GROUPS = ["dependencies", "devDependencies"]

    def current_packages
      json = npm_json
      dependencies = DEPENDENCY_GROUPS
        .map { |g| (json[g] || {}).values }
        .flatten(1)
        .reject{ |d| d.is_a?(String) }

      pkgs = {} # name => spec
      dependencies.each { |d| recursive_dependencies(d, pkgs) }
      pkgs.values.map { |d| NpmPackage.new(d, logger: logger) }
    end

    private

    def npm_json
      command = "npm list --json --long"
      output, success = capture(command)
      if success
        json = JSON(output)
      else
        json = begin
                 JSON(output)
               rescue JSON::ParserError
                 nil
               end
        if json
          $stderr.puts "Command #{command} returned error but parsing succeeded."
        else
          raise "Command #{command} failed to execute: #{output}"
        end
      end
      json
    end

    def capture(command)
      [`#{command}`, $?.success?]
    end

    def package_path
      project_path.join('package.json')
    end

    # node_module can be empty hash if it is included elsewhere
    def recursive_dependencies(node_module, memo)
      key = node_module['name']
      memo[key] ||= {}
      memo[key].merge!(node_module)
      node_module.fetch('dependencies', {}).each do |dep_key, data|
        data['name'] ||= dep_key
        recursive_dependencies(data, memo)
      end
      memo
    end
  end
end
