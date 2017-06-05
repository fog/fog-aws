module Fog
  module Parsers
    module AWS
      module ELBV2
        class DescribeAttributes < Fog::Parsers::Base
          def reset
            @attributes = {}
            @response = { self.class::RESULT_KEY => { }, 'ResponseMetadata' => {} }
          end

          def end_element(name)
            case name
            when 'member'
              @attributes[@key] = case @key
                                  when /enabled/
                                    @_value == 'true'
                                  when /seconds/
                                    @_value.to_i
                                  else
                                    @_value
                                  end
            when 'Key'
              @key = value
            when 'Value'
              @_value = value
            when 'Attributes'
              @response[self.class::RESULT_KEY]['Attributes'] = @attributes
            when 'RequestId'
              @response['ResponseMetadata'][name] = value
            end
          end
        end
      end
    end
  end
end
