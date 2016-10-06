module Fog
  module AWS
    class EFS
      class FileSystem < Fog::Model
        identity :id, :aliases => 'FileSystemId'

        attribute :owner_id,                :aliases => 'OwnerId'
        attribute :creation_token,          :aliases => 'CreationToken'
        attribute :performance_mode,        :aliases => 'PerformanceMode'
        attribute :creation_time,           :aliases => 'CreationTime'
        attribute :state,                   :aliases => 'LifeCycleState'
        attribute :name,                    :aliases => 'Name'
        attribute :number_of_mount_targets, :aliases => 'NumberOfMountTargets'
        attribute :size_in_bytes,           :aliases => 'SizeInBytes'

        def ready?
          state == 'available'
        end

        def mount_targets
          requires :identity
          service.mount_targets(:file_system_id => self.identity).all
        end

        def destroy
          requires :identity

          service.delete_file_system(:id => self.identity)

          true
        end

        def save
          params = {
            :creation_token => self.creation_token || Fog::Mock.random_hex(32)
          }

          params.merge!(:performance_mode => self.performance_mode) if self.performance_mode

          merge_attributes(service.create_file_system(:creation_token => self.creation_token).body)
        end
      end
    end
  end
end
