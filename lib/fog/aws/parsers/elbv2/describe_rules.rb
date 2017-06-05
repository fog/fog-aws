module Fog
  module Parsers
    module AWS
      module ELBV2
        class DescribeRules < Fog::Parsers::Base
          RESULT_KEY = 'DescribeRulesResult'

          def reset
            @rules = []
            @actions = []
            @conditions = []
            @condition_values = []
            @response = { self.class::RESULT_KEY => {}, 'ResponseMetadata' => {} }
          end

          def start_element(name, attrs = [])
            super
            case name
            when 'Rules'
              @in_rules = true
            when 'Actions'
              @in_actions = true
            when 'Conditions'
              @in_conditions = true
            when 'Values'
              @in_condition_values = true
            when 'member'
              if @in_actions
                @action = {}
              elsif @in_condition_values
              elsif @in_conditions
                @condition =  {}
              elsif @in_rules
                @rule = {}
              end
            end
          end

          def end_element(name)
            case name
            when 'member'
              if @in_actions
                @actions << @action
                @action = nil
              elsif @in_condition_values
                @condition_values << value
              elsif @in_conditions
                @conditions << @condition
                @condition = nil
              elsif @in_rules
                @rules << @rule
              end

            when 'Actions'
              @rule['Actions'] = @actions
              @actions = []
              @in_actions = false

            when 'Conditions'
              @rule['Conditions'] = @conditions
              @conditions = []
              @in_conditions = false

            when 'Values'
              if @in_conditions
                @condition['Values'] = @condition_values
                @condition_values = []
                @in_condition_values = false
              end

            when 'Rules'
              @response[self.class::RESULT_KEY]['Rules'] = @rules

            when 'IsDefault'
              @rule[name] = value == 'true' if @rule

            when 'Priority', 'RuleArn'
              @rule[name] = value if @rule

            when 'Type', 'TargetGroupArn'
              @action[name] = value if @action

            when 'Field'
              @condition['Field'] = value if @condition

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
