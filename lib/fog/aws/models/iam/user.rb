module Fog
  module AWS
    class IAM
      class User < Fog::Model
        identity  :id, :aliases => 'UserName'

        attribute :path,       :aliases => 'Path'
        attribute :arn,        :aliases => 'Arn'
        attribute :user_id,    :aliases => 'UserId'
        attribute :created_at, :aliases => 'CreateDate', :type => :time

        def access_keys
          requires :id

          service.access_keys(:username => id)
        end

        def destroy
          requires :id

          service.delete_user(id)
          true
        end

        def groups
          service.groups(:username => self.identity)
        end

        def policies
          requires :id

          service.policies(:username => id)
        end

        def password=(password)
          requires :identity

          has_password = !!self.password_created_at

          if has_password && password.nil?
            service.delete_login_profile(self.identity)
          elsif has_password
            service.update_login_profile(self.identity, password)
          elsif !password.nil?
            service.create_login_profile(self.identity, password)
          end
        end

        def password_created_at
          requires :identity

          service.get_login_profile(self.identity).body["LoginProfile"]["CreateDate"]
        rescue Fog::AWS::IAM::NotFound
          nil
        end

        def save
          requires :id
          data = service.create_user(id, path || '/').body['User']
          merge_attributes(data)
          true
        end
      end
    end
  end
end
