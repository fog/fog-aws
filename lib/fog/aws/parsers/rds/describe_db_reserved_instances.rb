module Fog
  module Parsers
    module AWS
      module RDS

        class DescribeDBReservedInstances < Fog::Parsers::Base

          def reset
            @reserved_instance = {}
            @recurring_charge = {}
            @recurring_charges = []
            @response = {'ReservedDBInstances' => []}
          end

          def end_element(name)
            case name
              when 'ReservedDBInstanceId', 'ReservedDBInstancesOfferingId', 'DBInstanceClass', 'ProductDescription', 'State'
                @reserved_instance[name] = value.strip
              when 'Duration', 'DBInstanceCount'
                @reserved_instance[name] = value.to_i
              when 'FixedPrice', 'UsagePrice'
                @reserved_instance[name] = value.to_f
              when 'ReservedDBInstance'
                @response['ReservedDBInstances'] << @reserved_instance
                @reserved_instance = {}
              when 'Marker'
                @response[name] = value
              when 'MultiAZ'
                if value == 'false'
                  @reserved_instance[name] = false
                else
                  @reserved_instance[name] = true
                end
              when 'StartTime'
                @reserved_instance[name] = Time.parse(value)
              when 'RecurringCharges'
                @reserved_instance[name] = @recurring_charges
              when 'RecurringCharge'
                @recurring_charges << @recurring_charge
                @recurring_charge = {}
              when 'RecurringChargeAmount'
                @recurring_charge[name] = value.to_f
              when 'RecurringChargeFrequency'
                @recurring_charge[name] = value.strip
            end
          end

        end

      end
    end
  end
end