module Fog
  module Parsers
    module AWS
      module ELBV2
        class DescribeTargetGroups < Fog::Parsers::Base
          RESULT_KEY = 'DescribeTargetGroupsResult'

          def reset
            @target_groups = []
            @arns = []
            @response = { self.class::RESULT_KEY => {}, 'ResponseMetadata' => {} }
          end

          def start_element(name, attrs = [])
            super
            case name
            when 'TargetGroups'
              @in_target_groups = true
            when 'LoadBalancerArns'
              @in_load_balancer_arns = true
            when 'Matcher'
              @in_matcher = true
            when 'member'
              if @in_load_balancer_arns
              elsif @in_target_groups
                @target_group = {}
              end
            end
          end

          def end_element(name)
            case name
            when 'member'
              if @in_load_balancer_arns
                @arns << value
              elsif @in_target_groups
                @target_groups << @target_group
                @target_group = nil
              end

            when 'Matcher'
              @in_matcher = false

            when 'LoadBalancerArns'
              @target_group['LoadBalancerArns'] = @arns
              @in_load_balancer_arns = false
              @arns = []

            when 'HttpCode'
              @target_group['Matcher.HttpCode'] = value if @in_matcher

            when 'TargetGroups'
              @response[self.class::RESULT_KEY]['TargetGroups'] = @target_groups

            when 'TargetGroupArn', 'HealthCheckPort', 'HealthCheckProtocol', 'TargetGroupName', 'HealthCheckPath', 'Protocol', 'VpcId'
              @target_group[name] = value if @target_group

            when 'HealthCheckIntervalSeconds', 'HealthCheckTimeoutSeconds', 'HealthyThresholdCount', 'UnhealthyThresholdCount', 'Port'
              @target_group[name] = value.to_i if @target_group
            when 'RequestId'
              @response['ResponseMetadata'][name] = value

            when 'NextMarker'
              @results['NextMarker'] = value
            end
          end
        end
      end
    end
  end
end
