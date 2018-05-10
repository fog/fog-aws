module Fog
  module AWS
    class ELBV2
      class Rule < Fog::Model
        identity  :id, :aliases => 'RuleArn'
        attribute :is_default, :aliases => 'IsDefault'
        attribute :priority, :aliases => 'Priority'
        attribute :actions, :aliases => 'Actions'
        attribute :conditions, :aliases => 'Conditions'

        attr_accessor :listener

        PATH_PATTERN = 'path-pattern'
        HOST_HEADER = 'host-header'

        def priority=(new_priority)
          requires :id
          service.set_rule_priorities(id => new_priority)
        end

        def target_group_ids
          actions.map { |action| action['TargetGroupArn'] }
        end

        def paths
          conditions.select { |condition| condition['Field'] == PATH_PATTERN }.map { |condition| condition['Values'].first }
        end

        def hosts
          conditions.select { |condition| condition['Field'] == HOST_HEADER }.map { |condition| condition['Values'].first }
        end

        def save
          resp = service.create_rule(listener.id, actions, conditions, :priority => priority)
          merge_attributes(resp.body['CreateRuleResult']['Rules'][0])
        end

        def update(tg_ids, conditions)
          requires :id
          actions = tg_ids.map { |tg_id| { 'Type' => 'forward', 'TargetGroupArn' => tg_id } }
          resp = service.modify_rule(id, actions, conditions)
          merge_attributes(resp.body['ModifyRuleResult']['Rules'].first)
        end

        def destroy
          requires :id
          service.delete_rule(id)
        end
      end
    end
  end
end
