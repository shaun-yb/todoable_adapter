require "spec_helper"

describe Adapter do
    let(:base_url) { "https://todoable.teachable.tech/api" }
    describe "#authenticate" do
        let(:adapter) do
            described_class.new(
                username: "Shaun",
                password: "Password",
                base_url: base_url
            )
        end
        let(:url) { base_url + "/authenticate" }
        let(:mock_response) { "foo" }

        context "when the call to the Todoable API fails" do
            it "raises an error (todo: check which one)" do
                HTTParty.stub(:post).and_raise("Cannot connect")
                expect { adapter.authenticate }.to raise_error
            end
        end
    end
end