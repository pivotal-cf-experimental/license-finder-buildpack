require 'feature_helper'

describe "Ignored Groups" do
  # As a developer
  # I want to ignore certain groups
  # So that license_finder skips any gems I use in development, or for testing

  let(:developer) { LicenseFinder::TestingDSL::User.new }

  specify "are excluded from reports" do
    project = developer.create_ruby_app
    gem = developer.create_gem 'dev_gem', license: 'GPL'
    project.depend_on gem, groups: ['dev']
    developer.execute_command 'license_finder ignored_group add dev'

    developer.run_license_finder
    expect(developer).to_not be_seeing 'dev_gem'
  end

  specify "appear in the CLI" do
    developer.create_empty_project
    developer.execute_command 'license_finder ignored_group add dev'
    expect(developer).to be_seeing 'dev'
    developer.execute_command 'license_finder ignored_group list'
    expect(developer).to be_seeing 'dev'

    developer.execute_command 'license_finder ignored_group remove dev'
    developer.execute_command 'license_finder ignored_group list'
    expect(developer).to_not be_seeing 'dev'
  end
end
