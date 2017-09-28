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
            resp = service.describe_rules(nil, identity)
            new(resp.body['DescribeRulesResult']['Rules'].first)
          end
        rescue Fog::AWS::ELB::NotFound
          nil
        end
      end
    end
  end
end
