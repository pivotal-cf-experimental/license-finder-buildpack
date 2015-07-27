require "spec_helper"

module LicenseFinder
  module CLI
    describe Approvals do
      let(:decisions) { Decisions.new }

      before do
        allow(Decisions).to receive(:saved!) { decisions }
      end

      describe "#add" do
        it "approves the requested gem" do
          silence_stdout do
            subject.add 'foo'
          end
          expect(subject.decisions).to be_approved "foo"
        end

        it "approves multiple dependencies" do
          silence_stdout do
            subject.add 'foo', 'bar'
          end
          expect(subject.decisions).to be_approved "foo"
          expect(subject.decisions).to be_approved "bar"
        end

        it "raises a warning if no dependency was specified" do
          silence_stdout do
            expect { subject.add }.to raise_error(ArgumentError)
          end
        end

        it "sets approver and approval message" do
          subject.options = {
            who: "Julian",
            why: "We really need this"
          }
          silence_stdout do
            subject.add("foo")
          end

          approval = subject.decisions.approval_of("foo")
          expect(approval.who).to eq "Julian"
          expect(approval.why).to eq "We really need this"
        end
      end

      describe "remove" do
        it "unapproves the specified dependency" do
          silence_stdout do
            subject.add("test")
            subject.remove("test")
          end
          expect(subject.decisions).not_to be_approved "test"
        end

        it "is cumulative" do
          silence_stdout do
            subject.add("test")
            subject.remove("test")
            subject.add("test")
          end
          expect(subject.decisions).to be_approved "test"
        end
      end
    end
  end
end
