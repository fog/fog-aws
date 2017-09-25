module Fog
  module Parsers
    module Compute
      module AWS
        class DescribeVpcs < Fog::Parsers::Base
          def reset
            @vpc = { 'tagSet' => {}, 'ipv6CidrBlockAssociationSet' => [], 'cidrBlockAssociationSet' => [] }
            @response = { 'vpcSet' => [] }
            @tag = {}
            @ipv6_cidr = {}
            @ipv4_cidr = {}
          end

          def start_element(name, attrs = [])
            super
            case name
            when 'tagSet'
              @in_tag_set = true
            when 'ipv6CidrBlockAssociationSet'
              @in_ipv6_set = true
            when 'cidrBlockAssociationSet'
              @in_ipv4_set = true              
            end
          end

          def end_element(name)
            if @in_tag_set
              case name
                when 'item'
                  @vpc['tagSet'][@tag['key']] = @tag['value']
                when 'key', 'value'
                  @tag[name] = value
                when 'tagSet'
                  @in_tag_set = false
              end
            elsif @in_ipv6_set
              case name
                when 'item'
                  @vpc['ipv6CidrBlockAssociationSet'].push(@ipv6_cidr)
                when 'ipv6CidrBlock', 'associationId'
                  @ipv6_cidr[name] = value
                when 'ipv6CidrBlockState'
                  @ipv6_cidr[name] = value.squish
                when 'ipv6CidrBlockAssociationSet'
                  @in_ipv6_set = false
              end
            elsif @in_ipv4_set
              case name
                when 'item'
                  @vpc['cidrBlockAssociationSet'].push(@ipv4_cidr)
                when 'cidrBlock', 'associationId'
                  @ipv4_cidr[name] = value
                when 'cidrBlockState'
                  @ipv4_cidr[name] = value.squish
                when 'cidrBlockAssociationSet'
                  @in_ipv4_set = false
              end              
            else
              case name
              when 'vpcId', 'state', 'cidrBlock', 'dhcpOptionsId', 'instanceTenancy'
                @vpc[name] = value
              when 'isDefault'
                @vpc['isDefault'] = value == 'true'        
              when 'item'
                @response['vpcSet'] << @vpc
                @vpc = { 'tagSet' => {}, 'ipv6CidrBlockAssociationSet' => [], 'cidrBlockAssociationSet' => [] }
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
