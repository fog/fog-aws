require 'fog/aws/models/iam/group'

module Fog
  module AWS
    class IAM
      class Groups < Fog::Collection

        attribute :truncated, :aliases => 'IsTruncated', :type => :boolean
        attribute :marker,    :aliases => 'Marker'
        attribute :username

        model Fog::AWS::IAM::Group

        def all(options = {})
          merge_attributes(options)

          data, records = if self.username
                            response = service.list_groups_for_user(self.username, options)
                            [response.body, response.body['GroupsForUser']]
                          else
                            response = service.list_groups(options)
                            [response.body, response.body['Groups']]
                          end

          merge_attributes(data)
          load(records)
        end

        def get(identity)
          data = service.get_group(identity)

          group = data.body['Group']
          users = data.body['Users'].map { |u| service.users.new(u) }

          new(group.merge(:users => users))
        rescue Fog::AWS::IAM::NotFound
          nil
        end

        def each
          if !block_given?
            self
          else
            subset = dup.all

            subset.each { |f| yield f }

            while subset.truncated
              subset = subset.all('Marker' => subset.marker, 'MaxItems' => 1000)
              subset.each { |f| yield f }
            end

            self
          end
        end
      end
    end
  end
end
