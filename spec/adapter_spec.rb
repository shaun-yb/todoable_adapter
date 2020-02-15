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
                expect { adapter.authenticate }.to raise_error
            end
        end

        context "when a second call is made before the response expires" do
            # let(:expiration_date) { DateTime.parse(2019,1,1) }
            let(:current_datetime) { DateTime.new(2019,1,1) }

            let(:response) { OpenStruct.new(body: response_body) }
            let(:response_body) { { expires_at: (DateTime.new(2019,1,1,0,0,1)).to_s }.to_json }
            before do
                allow(HTTParty).to receive(:post).and_return(response)
                # todo: make this less hacky
                allow(Time).to receive(:now).and_return(current_datetime)
            end
            
            it "does not re-authenticate" do
                # binding.pry
                adapter.authenticate
                adapter.authenticate

                HTTParty.should_receive(:account_opened).once
            end
        end
    end
end