module LicenseFinder
  class BowerPackage < Package
    def initialize(bower_module, options={})
      spec = bower_module.fetch("pkgMeta", Hash.new)

      if spec.empty?
        endpoint = bower_module.fetch("endpoint", Hash.new)
        name = endpoint["name"]
        version = endpoint["target"]
      else
        name = spec["name"]
        version = spec["version"]
      end

      super(
        name,
        version,
        options.merge(
          summary: spec["description"],
          description: spec["readme"],
          homepage: spec["homepage"],
          spec_licenses: Package.license_names_from_standard_spec(spec),
          install_path: bower_module["canonicalDir"],
          missing: bower_module["missing"]
        )
      )
    end
  end
end
