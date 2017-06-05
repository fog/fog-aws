module Fog
  module Parsers
    module AWS
      module ELBV2
        class DescribeTargetHealth < Fog::Parsers::Base
          def reset
            @target_health_descriptions = []
            @response = { 'DescribeTargetHealthResult' => {}, 'ResponseMetadata' => {} }
          end

          def start_element(name, attrs = [])
            super
            case name
            when 'member'
              @target_health_description = {}
            when 'Target'
              @in_target = true
              @target = {}
            when 'TargetHealth'
              @in_target_health = true
              @target_health = {}
            end
          end

          def end_element(name)
            case name
            when 'member'
              @target_health_descriptions << @target_health_description

            when 'HealthCheckPort'
              @target_health_description[name] = value

            when 'Id', 'Port'
              @target[name] = value if @in_target

            when 'Description', 'Reason', 'State'
              @target_health[name] = value if @in_target_health

            when 'Target'
              @target_health_description[name] = @target

            when 'TargetHealth'
              @target_health_description[name] = @target_health

            when 'Targets'
              @response['DescribeTargetHealthResult']['TargetHealthDescriptions'] = @target_health_descriptions

            when 'RequestId'
              @response['ResponseMetadata'][name] = value
            end
          end
        end
      end
    end
  end
end
