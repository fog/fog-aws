require 'fog/core/model'

module Fog
  module AWS
    class SNS
      class Topic < Fog::Model
        identity :id, :aliases => "TopicArn"

        attribute :owner,                     :aliases => "Owner"
        attribute :policy,                    :aliases => "Policy"
        attribute :display_name,              :aliases => "DisplayName"
        attribute :subscriptions_pending,     :aliases => "SubscriptionsPending"
        attribute :subscriptions_confirmed,   :aliases => "SubscriptionsConfirmed"
        attribute :subscriptions_deleted,     :aliases => "SubscriptionsDeleted"
        attribute :delivery_policy,           :aliases => "DeliveryPolicy"
        attribute :effective_delivery_policy, :aliases => "EffectiveDeliveryPolicy"

        def ready?
          display_name
        end

        def update_topic_attribute(attribute, new_value)
          requires :id
          service.set_topic_attributes(id, attribute, new_value).body
          reload
        end

        def destroy
          requires :id
          service.delete_topic(id)
          true
        end

        def save
          requires_one :id, :display_name

          name = if id
                   Fog::Logger.deprecation("#{self.class}#save with #id is deprecated, use display_name instead [light_black](#{caller.first})[/]")
                   id
                 else
                   display_name
                 end

          if identity = service.create_topic(name).body["TopicArn"]
            merge_attributes("id" => identity)
            true
          else false
          end
        end
      end
    end
  end
end
