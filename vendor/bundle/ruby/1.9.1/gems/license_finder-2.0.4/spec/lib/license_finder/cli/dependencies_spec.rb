require "spec_helper"

module LicenseFinder
  module CLI
    describe Dependencies do
      let(:decisions) { Decisions.new }

      before do
        allow(Decisions).to receive(:saved!) { decisions }
      end

      describe "add" do
        it "adds a dependency" do
          silence_stdout do
            subject.add("js_dep", "MIT", "1.2.3")
          end

          expect(subject.decisions.packages.size).to eq 1
          package = subject.decisions.packages.first
          expect(package.name).to eq "js_dep"
          expect(package.version).to eq "1.2.3"
          expect(subject.decisions.licenses_of("js_dep")).to eq [License.find_by_name("MIT")].to_set
        end

        it "does not require a version" do
          silence_stdout do
            subject.add("js_dep", "MIT")
          end
          package = subject.decisions.packages.first
          expect(package.version).to be_nil
        end

        it "has an --approve option to approve the added dependency" do
          subject.options = { approve: true, who: "Julian", why: "We really need this" }
          silence_stdout do
            subject.add("js_dep", "MIT")
          end
          approval = subject.decisions.approval_of("js_dep")
          expect(approval.who).to eq "Julian"
          expect(approval.why).to eq "We really need this"
        end
      end

      describe "remove" do
        it "removes a dependency" do
          silence_stdout do
            subject.add("js_dep", "MIT")
            subject.remove("js_dep")
          end
          expect(subject.decisions.packages).to be_empty
        end
      end

      describe "list" do
        it "lists manually added dependencies" do
          decisions.add_package("custom", nil)
          expect(capture_stdout { subject.list }).to match /custom/
        end
      end
    end
  end
end
