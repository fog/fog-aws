require 'spec_helper'

RSpec.describe "Fog::AWS::SNS::Topics", :sns do
  include_examples "collection", Fog::AWS[:sns].topics, {:display_name => 'fog'}
end
