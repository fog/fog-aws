module Fog
  module AWS
    class EFS
      class MountTarget < Fog::Model
        attr_accessor :security_groups

        identity :id, :aliases => "MountTargetId"

        attribute :file_system_id,       :aliases => "FileSystemId"
        attribute :ip_address,           :aliases => "IpAddress"
        attribute :state,                :aliases => "LifeCycleState"
        attribute :network_interface_id, :aliases => "NetworkInterfaceId"
        attribute :owner_id,             :aliases => "OwnerId"
        attribute :subnet_id,            :aliases => "SubnetId"

        def ready?
          state == 'available'
        end


        def destroy
          requires :identity
          service.delete_mount_target(:id => self.identity)
          true
        end

        def file_system
          requires :file_system_id
          service.file_systems.get(self.file_system_id)
        end

        def save
          requires :file_system_id, :subnet_id
          params = {
            :file_system_id => self.file_system_id,
            :subnet_id      => self.subnet_id,
          }

          params.merge!('IpAddress' => self.ip_address) if self.ip_address
          params.merge!('SecurityGroups' => self.security_groups) if self.security_groups

          merge_attributes(service.create_mount_target(params).body)
        end
      end
    end
  end
end
