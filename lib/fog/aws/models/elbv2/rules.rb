require 'fog/aws/models/elbv2/rule'

module Fog
  module AWS
    class ELBV2
      class Rules < Fog::Collection
        model Fog::AWS::ELBV2::Rule

        attr_accessor :listener

        def all
          result = []
          marker = nil
          finished = false
          params = {}
          until finished
            data = service.describe_rules(listener.id, [], :marker => marker).body
            result.concat(data['DescribeRulesResult']['Rules'])
            marker = data['DescribeRulesResult']['NextMarker']
            finished = marker.nil?
          end
          load(result) # data is an array of attribute hashes
        end

        def new(attributes = {})
          super(attributes.merge(:listener => listener))
        end

        def get(identity)
          if identity
            resp = service.describe_rules(nil, [*identity])
            rules = resp.body['DescribeRulesResult']['Rules']
            return nil if rules.empty?
            new(rules.first)
          end
        rescue Fog::AWS::ELB::NotFound
          nil
        end

        def describe(rule_ids = nil, listener_id = nil)
          unless rule_ids || listener_id
            raise Fog::Errors::Error.new('No identity or listener id provided')
          end
          if rule_ids && listener_id
            raise Fog::Errors::Error.new('Listener id and rule ids cannot be specified at the same time')
          end

          result = []
          marker = nil
          finished = false
          params = true
          until finished
            data = service.describe_rules(listener_id, rule_ids, marker: marker).body
            result.concat(data['DescribeRulesResult']['Rules'])
            marker = data['DescribeRulesResult']['NextMarker']
            finished = !marker
          end
          load(result)
        end
      end
    end
  end
end
