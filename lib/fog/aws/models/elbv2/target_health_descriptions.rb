module Fog
  module AWS
    class ELBV2
      class TargetHealthDescriptions < Fog::Collection
        model Fog::AWS::ELBV2::TargetHealthDescription

        attr_accessor :target_ids, :target_group

        def all
          load(data)
        end

        def get(target_id)
          all.find { |target_health_description| target_health_description.target_id == target_id}
        end

        def data
          service.describe_target_health(target_group.id, target_ids).body['DescribeTargetHealthResult']['TargetHealthDescriptions']
        end
      end
    end
  end
end
