require "spec_helper"
require "date"

describe Adapter do
    let(:base_uri) { "https://todoable.teachable.tech/api" }

    describe "#authenticate" do
        let(:adapter) do
            described_class.new(
                username: "Shaun",
                password: "Password",
                base_uri: base_uri
            )
        end
        
        context "when the call to the Todoable API fails" do
            it "raises an error (todo: check which one)" do
                HTTParty.stub(:post).and_raise("Cannot connect")
                expect { adapter.authenticate }.to raise_error(AdapterError)
            end
        end

        context "when a second call is made before the response expires" do
            let(:current_datetime) { DateTime.new(2019,1,1) }
            let(:mocked_response) {{ "token" => "foo", "expires_at" => current_datetime.to_s }}
            
            before do
                allow(described_class).to receive(:post).and_return(mocked_response)
                allow(DateTime).to receive(:now).and_return(current_datetime)
            end
            
            it "does not re-authenticate" do
                described_class.should_receive(:post).once

                adapter.authenticate
                adapter.authenticate
            end
        end
    end
end