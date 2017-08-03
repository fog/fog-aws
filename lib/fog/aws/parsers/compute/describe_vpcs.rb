module Fog
  module Parsers
    module Compute
      module AWS
        class DescribeVpcs < Fog::Parsers::Base
          def reset
            @vpc = { 'tagSet' => {}, 'ipv6CidrBlockAssociationSet' => {} }
            @response = { 'vpcSet' => [] }
            @tag = {}
          end

          def start_element(name, attrs = [])
            super
            case name
            when 'tagSet'
              @in_tag_set = true
            when 'ipv6CidrBlockAssociationSet'
              @in_ipv6_set = true
            end
          end

          def end_element(name)
            if @in_tag_set
              case name
                when 'item'
                  @vpc['tagSet'][@tag['key']] = @tag['value']
                  @tag = {}
                when 'key', 'value'
                  @tag[name] = value
                when 'tagSet'
                  @in_tag_set = false
              end
            elsif @in_ipv6_set
              case name
              when 'ipv6CidrBlock', 'associationId'
                @vpc['ipv6CidrBlockAssociationSet'][name] = value
              when 'ipv6CidrBlockState'
                @vpc['ipv6CidrBlockAssociationSet'][name] = {'State' => value.squish}
              when 'ipv6CidrBlockAssociationSet'
                @vpc['amazonProvidedIpv6CidrBlock'] = !value.blank?
                @in_ipv6_set = false
              end
            else
              case name
              when 'vpcId', 'state', 'cidrBlock', 'dhcpOptionsId', 'instanceTenancy'
                @vpc[name] = value
              when 'isDefault'
                @vpc['isDefault'] = value == 'true'        
              when 'item'
                @response['vpcSet'] << @vpc
                @vpc = { 'tagSet' => {}, 'ipv6CidrBlockAssociationSet' => {} }
              when 'requestId'
                @response[name] = value
              end
            end
          end
        end
      end
    end
  end
end
