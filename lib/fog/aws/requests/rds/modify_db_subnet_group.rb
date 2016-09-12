module Fog
  module AWS
    class RDS
      class Real
        require 'fog/aws/parsers/rds/modify_db_subnet_group.rb'

        # Creates a db subnet group
        # http://docs.aws.amazon.com/AmazonRDS/2012-01-15/APIReference/API_ModifyDBSubnetGroup.html
        # ==== Parameters
        # * DBSubnetGroupName <~String> - The name for the DB Subnet Group. This value is stored as a lowercase string. Must contain no more than 255 alphanumeric characters or hyphens. Must not be "Default".
        # * SubnetIds <~Array> - The EC2 Subnet IDs for the DB Subnet Group.
        # * DBSubnetGroupDescription <~String> - The description for the DB Subnet Group
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def modify_db_subnet_group(name, subnet_ids, description = nil)
          params = { 'Action'  => 'ModifyDBSubnetGroup',
            'DBSubnetGroupName' => name,
            'DBSubnetGroupDescription' => description,
            :parser   => Fog::Parsers::AWS::RDS::ModifyDBSubnetGroup.new }
          params.merge!(Fog::AWS.indexed_param("SubnetIds.member", Array(subnet_ids)))
          request(params)
        end
      end
    end
  end
end

=begin
rds.modify_db_subnet_group('kd-subnet-group', ['subnet-5259d03a', 'subnet-eb518f83'], 'hahaha!') #=>
  {:subnets=>
    [{:availability_zone=>
       {:name=>"us-east-1d", :provisioned_iops_capable=>false},
      :status=>"Active",
      :subnet_id=>"subnet-5259d03a"},
     {:availability_zone=>
       {:name=>"us-east-1a", :provisioned_iops_capable=>false},
      :status=>"Active",
      :subnet_id=>"subnet-eb518f83"}],
   :vpc_id=>"vpc-10518f78",
   :status=>"Complete",
   :description=>"hahaha!",
   :name=>"kd-subnet-group"}
=end