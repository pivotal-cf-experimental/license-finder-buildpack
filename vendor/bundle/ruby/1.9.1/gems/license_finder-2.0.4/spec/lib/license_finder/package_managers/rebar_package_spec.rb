require 'spec_helper'

module LicenseFinder
  describe RebarPackage do
    subject do
      described_class.new(
        "uuid",
        "TAG: v1.3.2",
        install_path: "deps/uuid",
        homepage: "git://github.com/okeuday/uuid.git"
      )
    end

    its(:name) { should == "uuid" }
    its(:version) { should == "TAG: v1.3.2" }
    its(:summary) { should eq "" }
    its(:description) { should == "" }
    its(:homepage) { should == "git://github.com/okeuday/uuid.git" }
    its(:groups) { should == [] }
    its(:children) { should == [] }
    its(:install_path) { should eq "deps/uuid" }
  end
end
