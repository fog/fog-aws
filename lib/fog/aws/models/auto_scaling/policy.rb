module Fog
  module AWS
    class AutoScaling
      class Policy < Fog::Model
        identity :id,                             :aliases => 'PolicyName'
        attribute :arn,                           :aliases => 'PolicyARN'
        attribute :type,                          :aliases => 'PolicyType'
        attribute :adjustment_type,               :aliases => 'AdjustmentType'
        attribute :scaling_adjustment,            :aliases => 'ScalingAdjustment'
        attribute :step_adjustments,              :aliases => 'StepAdjustments'
        attribute :target_tracking_configuration, :aliases => 'TargetTrackingConfiguration'
        attribute :alarms,                        :aliases => 'Alarms'
        attribute :auto_scaling_group_name,       :aliases => 'AutoScalingGroupName'
        attribute :cooldown,                      :aliases => 'Cooldown'
        attribute :estimated_instance_warmup,     :aliases => 'EstimatedInstanceWarmup'
        attribute :metric_aggregation_type,       :aliases => 'MetricAggregationType'
        attribute :min_adjustment_magnitude,      :aliases => 'MinAdjustmentMagnitude'
        attribute :min_adjustment_step,           :aliases => 'MinAdjustmentStep'

        STEP_ADJUSTMENTS_MAPPING = {
          :metric_interval_lower_bound => 'MetricIntervalLowerBound',
          :metric_interval_upper_bound => 'MetricIntervalUpperBound',
          :scaling_adjustment          => 'ScalingAdjustment'
        }.freeze

        TARGET_TRACKING_MAPPING = {
          :customized_metric_specification => {
            'CustomizedMetricSpecification' => {
              :metric_name => 'MetricName',
              :namespace   => 'Namespace',
              :statistics  => 'Statistics',
              :unit        => 'Unit',
              :dimensions  => {
                'Dimensions' => {
                  :name  => 'Name',
                  :value => 'Value'
                }
              }
            }
          },
          :disable_scale_in                => 'DisableScaleIn',
          :target_value                    => 'TargetValue',
          :predefined_metric_specification => {
            'PredefinedMetricSpecification' => {
              :predefined_metric_type => 'PredefinedMetricType',
              :resource_label         => 'ResourceLabel'
            }
          }
        }.freeze

        # Returns attribute names specific for different policy types
        #
        # ==== Parameters
        # * policy_type<~String> - type of the auto scaling policy
        #
        # ==== Returns
        # * options<~Array> Array of string containing policy specific options
        #
        def self.preserve_options(policy_type)
          case policy_type
          when 'StepScaling'
            %w(EstimatedInstanceWarmup PolicyType MinAdjustmentMagnitude MetricAggregationType AdjustmentType StepAdjustments)
          when 'TargetTrackingScaling'
            %w(EstimatedInstanceWarmup PolicyType TargetTrackingConfiguration)
          else
            %w(AdjustmentType ScalingAdjustment PolicyType Cooldown MinAdjustmentMagnitude MinAdjustmentStep)
          end
        end

        def initialize(attributes)
          super
          case self.type
          when 'StepScaling'
            prepare_step_policy
          when 'TargetTrackingScaling'
            prepare_target_policy
          else
            prepare_simple_policy
          end
        end

        # TODO: implement #alarms

        def auto_scaling_group
          service.groups.get(self.auto_scaling_group_name)
        end

        def save
          type_requirements

          options = Hash[self.class.aliases.map { |key, value| [key, send(value)] }]
          if options['TargetTrackingConfiguration']
            options['TargetTrackingConfiguration'] = Fog::AWS.map_to_aws(options['TargetTrackingConfiguration'], TARGET_TRACKING_MAPPING)
          end
          if options['StepAdjustments']
            options['StepAdjustments'] = Fog::AWS.map_to_aws(options['StepAdjustments'], STEP_ADJUSTMENTS_MAPPING)
          end
          options_keys = self.class.preserve_options(self.type)
          options.delete_if { |key, value| value.nil? || !options_keys.include?(key) }

          service.put_scaling_policy(auto_scaling_group_name, id, options)
          reload
        end

        def destroy
          requires :id
          requires :auto_scaling_group_name
          service.delete_policy(auto_scaling_group_name, id)
        end

        private

        def prepare_simple_policy
          self.adjustment_type    ||= 'ChangeInCapacity'
          self.scaling_adjustment ||= 1
        end

        def prepare_target_policy
          # do we need default tracking configuration or should we just allow it to fail?
          if target_tracking_configuration
            self.target_tracking_configuration = Fog::AWS.map_from_aws(target_tracking_configuration, TARGET_TRACKING_MAPPING)
          end
        end

        def prepare_step_policy
          # do we need any default scaling steps or should we just allow it to fail?
          self.adjustment_type ||= 'ChangeInCapacity'
          if step_adjustments
            self.step_adjustments = Fog::AWS.map_from_aws(step_adjustments, STEP_ADJUSTMENTS_MAPPING)
          end
        end

        def type_requirements
          requires :id
          requires :auto_scaling_group_name
          case self.type
          when 'StepScaling'
            requires :step_adjustments
          when 'TargetTrackingScaling'
            requires :target_tracking_configuration
          else
            requires :scaling_adjustment
          end
        end
      end
    end
  end
end
