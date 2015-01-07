require 'spec_helper'

RSpec.describe "Fog::AWS::SNS::Topic" do
  before(:all) { @topic = Fog::AWS[:sns].topics.new(display_name: 'fog') }
  subject      { @topic }

  it "should #save" do
    expect {
      subject.save
    }.to change { subject.id }.from(nil)
  end

  it "should #update_topic_attribute" do
    expect {
      subject.update_topic_attribute("DisplayName", "new-fog")
    }.to change { subject.display_name }.to("new-fog")
  end

  it "should #destroy" do
    expect {
      subject.destroy
    }.to change { subject.reload }.to(nil)
  end
end
