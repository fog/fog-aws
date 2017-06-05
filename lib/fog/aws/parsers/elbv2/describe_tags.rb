module Fog
  module Parsers
    module AWS
      module ELBV2
        # parses an XML-formatted list of resource tags from AWS
        class DescribeTags < Fog::Parsers::Base

          # each tag is modeled as a String pair (2-element Array)
          def reset
            @this_key   = nil
            @this_value = nil
            @tags       = Hash.new
            @response   = { 'DescribeTagsResult' => { 'TagDescriptions' => [] }, 'ResponseMetadata' => {} }
            @in_tags = false
          end

          def start_element(name, attrs = [])
            super
            case name
            when 'member'
              unless @in_tags
                @load_balancer_name = nil
                @tags = {}
              end
            when 'Tags'
              @in_tags = true
            end
          end

          def end_element(name)
            case name
            when 'member'
              if @in_tags
                @tags[@this_key] = @this_value
                @this_key, @this_value = nil, nil
              else
                @response['DescribeTagsResult']['TagDescriptions'] << { 'Tags' => @tags, 'ResourceArn' => @resource_arn }
              end
            when 'Tags'
              @in_tags = false
            when 'Key'
              @this_key = value
            when 'Value'
              @this_value = value
            when 'ResourceArn'
              @resource_arn = value
            when 'RequestId'
              @response['ResponseMetadata'][name] = value
            end
          end

        end
      end
    end
  end
end
