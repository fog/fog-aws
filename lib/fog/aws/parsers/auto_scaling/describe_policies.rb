module Fog
  module Parsers
    module AWS
      module AutoScaling
        class DescribePolicies < Fog::Parsers::Base

          NESTING_MEMBERS = %w(scaling_policy alarm dimension target_tracking step_adjustment custom_spec predefined_spec).freeze

          def reset
            NESTING_MEMBERS.each do |obj|
              public_send(:"reset_#{obj}")
            end
            @results = { 'ScalingPolicies' => [] }
            @response = { 'DescribePoliciesResult' => {}, 'ResponseMetadata' => {} }
            (NESTING_MEMBERS - ['scaling_policy']).each do |member|
              instance_variable_set(:"@in_#{member}", false)
            end
          end

          (NESTING_MEMBERS - ['scaling_policy']).each do |obj|
            define_method(:"reset_#{obj}") do
              instance_variable_set(:"@#{obj}", {})
            end
          end

          def reset_scaling_policy
            @scaling_policy = { 'Alarms' => [], 'StepAdjustments' => [] }
          end

          def start_element(name, attrs = [])
            super
            case name
            when 'Alarms'
              @in_alarms = true
            when 'TargetTrackingConfiguration'
              @in_target_tracking = true
            when 'StepAdjustments'
              @in_step_adjustments = true
            when 'Dimensions'
              @in_dimensions = true
            when 'CustomizedMetricSpecification'
              @in_custom_spec = true
            when 'PredefinedMetricSpecification'
              @in_predefined_spec = true
            end
          end

          def end_element(name)
            case name
            when 'AlarmARN', 'AlarmName'
              @alarm[name] = value
            when 'MetricName', 'Statistics', 'Unit', 'Namespace'
              @custom_spec[name] = value
            when 'Name', 'Value'
              @dimension[name] = value
            when 'AdjustmentType', 'AutoScalingGroupName', 'MetricAggregationType', 'PolicyARN', 'PolicyName', 'PolicyType'
              @scaling_policy[name] = value
            when 'PredefinedMetricType', 'ResourceLabel'
              @predefined_spec[name] = value
            when 'Cooldown', 'MinAdjustmentStep', 'MinAdjustmentMagnitude', 'EstimatedInstanceWarmup'
              @scaling_policy[name] = value.to_i
            when 'DisableScaleIn'
              @target_tracking[name] = (value == 'true')
            when 'TargetValue'
              @target_tracking[name] = value.to_f
            when 'MetricIntervalLowerBound', 'MetricIntervalUpperBound'
              @step_adjustment[name] = value.nil? ? value : value.to_f
            when 'ScalingAdjustment'
              if @in_step_adjustments
                @step_adjustment[name] = value.to_i
              else
                @scaling_policy[name] = value.to_i
              end
            when 'NextToken'
              @results[name] = value
            when 'RequestId'
              @response['ResponseMetadata'][name] = value
            when 'DescribePoliciesResponse'
              @response['DescribePoliciesResult'] = @results
            when 'Alarms'
              @in_alarms = false
            when 'TargetTrackingConfiguration'
              @in_target_tracking = false
              @scaling_policy['TargetTrackingConfiguration'] = @target_tracking
              reset_target_tracking
            when 'StepAdjustments'
              @in_step_adjustments = false
            when 'Dimensions'
              @in_dimensions = false
            when 'CustomizedMetricSpecification'
              @in_custom_spec = false
              @target_tracking['CustomizedMetricSpecification'] = @custom_spec
              reset_custom_spec
            when 'PredefinedMetricSpecification'
              @in_predefined_spec = false
              @target_tracking['PredefinedMetricSpecification'] = @predefined_spec
              reset_predefined_spec
            when 'member'
              if @in_alarms
                @scaling_policy['Alarms'] << @alarm
                reset_alarm
              elsif @in_step_adjustments
                @scaling_policy['StepAdjustments'] << @step_adjustment
                reset_step_adjustment
              elsif @in_dimensions
                @custom_spec['Dimensions'] ||= []
                @custom_spec['Dimensions'] << @dimension
                reset_dimension
              else
                @results['ScalingPolicies'] << @scaling_policy
                reset_scaling_policy
              end
            end
          end
        end
      end
    end
  end
end
