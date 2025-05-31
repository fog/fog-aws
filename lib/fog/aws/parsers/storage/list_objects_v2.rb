module Fog
  module Parsers
    module AWS
      module Storage
        class ListObjectsV2 < Fog::Parsers::Base
          # Initialize parser state
          def initialize
            super
            @common_prefix = {}
            @object = { 'Owner' => {} }
            reset
          end

          def reset
            @object = { 'Owner' => {} }
            @response = { 'Contents' => [], 'CommonPrefixes' => [] }
          end

          def start_element(name, attrs = [])
            super
            case name
            when 'CommonPrefixes'
              @in_common_prefixes = true
            end
          end

          def end_element(name)
            case name
            when 'CommonPrefixes'
              @in_common_prefixes = false
            when 'Contents'
              @response['Contents'] << @object
              @object = { 'Owner' => {} }
            when 'DisplayName', 'ID'
              @object['Owner'][name] = value
            when 'ETag'
              @object[name] = value.gsub('"', '') if value != nil
            when 'IsTruncated'
              if value == 'true'
                @response['IsTruncated'] = true
              else
                @response['IsTruncated'] = false
              end
            when 'LastModified'
              @object['LastModified'] = Time.parse(value)
            when 'ContinuationToken', 'NextContinuationToken', 'Name', 'StartAfter'
              @response[name] = value
            when 'MaxKeys', 'KeyCount'
              @response[name] = value.to_i
            when 'Prefix'
              if @in_common_prefixes
                @response['CommonPrefixes'] << value
              else
                @response[name] = value
              end
            when 'Size'
              @object['Size'] = value.to_i
            when 'Delimiter', 'Key', 'StorageClass'
              @object[name] = value
            end
          end
        end
      end
    end
  end
end 