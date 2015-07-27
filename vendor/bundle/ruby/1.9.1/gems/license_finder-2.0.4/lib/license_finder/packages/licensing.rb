require 'license_finder/packages/activation'

module LicenseFinder
  Licensing = Struct.new(:package, :decided_licenses, :licenses_from_spec, :license_files) do

    # Implements the algorithm for choosing the right set of licenses from
    # among the various sources of licenses we know about.  In order of
    # priority, licenses come from decisions, package specs, or package files.
    def activations
      case
      when activations_from_decisions.any? then activations_from_decisions
      when activations_from_spec.any?      then activations_from_spec
      when activations_from_files.any?     then activations_from_files
      else                                      [default_activation]
      end
    end

    def activations_from_decisions
      @afd ||= decided_licenses
        .map { |license| Activation::FromDecision.new(package, license) }
    end

    def activations_from_spec
      @afs ||= licenses_from_spec
        .map { |license| Activation::FromSpec.new(package, license) }
    end

    def activations_from_files
      @aff ||= license_files
        .group_by(&:license)
        .map { |license, files| Activation::FromFiles.new(package, license, files) }
    end

    def default_activation
      default_license = License.find_by_name nil
      Activation::None.new(package, default_license)
    end
  end
end
