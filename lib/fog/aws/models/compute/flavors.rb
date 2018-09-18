require 'fog/aws/models/compute/flavor'

module Fog
  module AWS
    class Compute
      FLAVORS = [
        {
          :id                      => 't1.micro',
          :name                    => 'Micro Instance',
          :bits                    => 32,
          :cores                   => 1,
          :disk                    => 0,
          :ram                     => 658,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 't2.nano',
          :name                    => 'Nano Instance',
          :bits                    => 64,
          :cores                   => 1,
          :disk                    => 0,
          :ram                     => 536,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 't2.micro',
          :name                    => 'Micro Instance',
          :bits                    => 64,
          :cores                   => 1,
          :disk                    => 0,
          :ram                     => 1073,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 't2.small',
          :name                    => 'Micro Instance',
          :bits                    => 64,
          :cores                   => 1,
          :disk                    => 0,
          :ram                     => 2147,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 't2.medium',
          :name                    => 'Micro Instance',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 0,
          :ram                     => 4294,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 't2.large',
          :name                    => 'Micro Instance',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 0,
          :ram                     => 8589,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 't2.xlarge',
          :name                    => 'Micro Instance',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 0,
          :ram                     => 17179,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 't2.2xlarge',
          :name                    => 'Micro Instance',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 0,
          :ram                     => 34359,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'm1.small',
          :name                    => 'Small Instance',
          :bits                    => 32,
          :cores                   => 1,
          :disk                    => 160,
          :ram                     => 1825,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'm1.medium',
          :name                    => 'Medium Instance',
          :bits                    => 32,
          :cores                   => 1,
          :disk                    => 400,
          :ram                     => 4026,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'm1.large',
          :name                    => 'Large Instance',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 850,
          :ram                     => 8053,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'm1.xlarge',
          :name                    => 'Extra Large Instance',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 1690,
          :ram                     => 16106,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 4
        },
        {
          :id                      => 'c1.medium',
          :bits                    => 32,
          :cores                   => 2,
          :disk                    => 350,
          :name                    => 'High-CPU Medium',
          :ram                     => 1825,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'c1.xlarge',
          :name                    => 'High-CPU Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 1690,
          :ram                     => 7516,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 4
        },
        {
          :id                      => 'c3.large',
          :name                    => 'C3 Large',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 32,
          :ram                     => 4026,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'c3.xlarge',
          :name                    => 'C3 Extra Large',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 80,
          :ram                     => 8053,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'c3.2xlarge',
          :name                    => 'C3 Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 160,
          :ram                     => 16106,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'c3.4xlarge',
          :name                    => 'C3 Quadruple Extra Large',
          :bits                    => 64,
          :cores                   => 16,
          :disk                    => 320,
          :ram                     => 32212,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'c3.8xlarge',
          :name                    => 'C3 Eight Extra Large',
          :bits                    => 64,
          :cores                   => 32,
          :disk                    => 640,
          :ram                     => 64424,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'c4.large',
          :name                    => 'C4 Large',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 0,
          :ram                     => 4026,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'c4.xlarge',
          :name                    => 'C4 Extra Large',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 0,
          :ram                     => 8053,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'c4.2xlarge',
          :name                    => 'C4 Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 0,
          :ram                     => 16106,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'c4.4xlarge',
          :name                    => 'C4 Quadruple Extra Large',
          :bits                    => 64,
          :cores                   => 16,
          :disk                    => 0,
          :ram                     => 32212,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'c4.8xlarge',
          :name                    => 'C4 Eight Extra Large',
          :bits                    => 64,
          :cores                   => 36,
          :disk                    => 0,
          :ram                     => 64424,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'c5.large',
          :name                    => 'C5 Large',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 0,
          :ram                     => 4294,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'c5.xlarge',
          :name                    => 'C5 Extra Large',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 0,
          :ram                     => 8589,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'c5.2xlarge',
          :name                    => 'C5 Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 0,
          :ram                     => 17179,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'c5.4xlarge',
          :name                    => 'C5 Quadruple Extra Large',
          :bits                    => 64,
          :cores                   => 16,
          :disk                    => 0,
          :ram                     => 34359,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'c5.9xlarge',
          :name                    => 'C5 Nine Extra Large',
          :bits                    => 64,
          :cores                   => 36,
          :disk                    => 0,
          :ram                     => 77309,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'c5.18xlarge',
          :name                    => 'C5 Eighteen Extra Large',
          :bits                    => 64,
          :cores                   => 72,
          :disk                    => 0,
          :ram                     => 154618,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'g2.2xlarge',
          :name                    => 'GPU Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 60,
          :ram                     => 16106,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'g2.8xlarge',
          :name                    => 'GPU Eight Extra Large',
          :bits                    => 64,
          :cores                   => 32,
          :disk                    => 240,
          :ram                     => 64424,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'hs1.8xlarge',
          :name                    => 'High Storage Eight Extra Large',
          :bits                    => 64,
          :cores                   => 16,
          :disk                    => 50331648,
          :ram                     => 125627,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 24
        },
        {
          :id                      => 'm2.xlarge',
          :name                    => 'High-Memory Extra Large',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 420,
          :ram                     => 18360,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'm2.2xlarge',
          :name                    => 'High Memory Double Extra Large',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 850,
          :ram                     => 36721,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'm2.4xlarge',
          :name                    => 'High Memory Quadruple Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 1690,
          :ram                     => 73443,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'cr1.8xlarge',
          :name                    => 'High Memory Eight Extra Large',
          :bits                    => 64,
          :cores                   => 32,
          :disk                    => 240,
          :ram                     => 261993,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'm3.medium',
          :name                    => 'M3 Medium',
          :bits                    => 64,
          :cores                   => 1,
          :disk                    => 4,
          :ram                     => 4026,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'm3.large',
          :name                    => 'M3 Large',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 32,
          :ram                     => 8053,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'm3.xlarge',
          :name                    => 'M3 Extra Large',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 80,
          :ram                     => 16106,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'm3.2xlarge',
          :name                    => 'M3 Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 160,
          :ram                     => 32212,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 2
        },
        {
          :id                      => "hi1.4xlarge",
          :name                    => "High I/O Quadruple Extra Large Instance",
          :bits                    => 64,
          :cores                   =>  35,
          :disk                    => 2048,
          :ram                     => 61952,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'cc1.4xlarge',
          :name                    => 'Cluster Compute Quadruple Extra Large',
          :bits                    => 64,
          :cores                   => 33.5,
          :disk                    => 1690,
          :ram                     => 23552,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'cc2.8xlarge',
          :name                    => 'Cluster Compute Eight Extra Large',
          :bits                    => 64,
          :cores                   => 32,
          :disk                    => 3370,
          :ram                     => 64961,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 4
        },
        {
          :id                      => 'cg1.4xlarge',
          :name                    => 'Cluster GPU Quadruple Extra Large',
          :bits                    => 64,
          :cores                   => 33.5,
          :disk                    => 1690,
          :ram                     => 22528,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'i2.xlarge',
          :name                    => 'I2 Extra Large',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 800,
          :ram                     => 32749,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'i2.2xlarge',
          :name                    => 'I2 Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 1600,
          :ram                     => 65498,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'i2.4xlarge',
          :name                    => 'I2 Quadruple Extra Large',
          :bits                    => 64,
          :cores                   => 16,
          :disk                    => 3200,
          :ram                     => 130996,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 4
        },
        {
          :id                      => 'i2.8xlarge',
          :name                    => 'I2 Eight Extra Large',
          :bits                    => 64,
          :cores                   => 32,
          :disk                    => 6400,
          :ram                     => 261993,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 8
        },
        {
          :id                      => 'i3.large',
          :name                    => 'I3 Large',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 475,
          :ram                     => 16374,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'i3.xlarge',
          :name                    => 'I3 Extra Large',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 950,
          :ram                     => 32749,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'i3.2xlarge',
          :name                    => 'I3 Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 1900,
          :ram                     => 65498,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'i3.4xlarge',
          :name                    => 'I3 Quadruple Extra Large',
          :bits                    => 64,
          :cores                   => 16,
          :disk                    => 3800,
          :ram                     => 130996,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'i3.8xlarge',
          :name                    => 'I3 Eight Extra Large',
          :bits                    => 64,
          :cores                   => 32,
          :disk                    => 7600,
          :ram                     => 261993,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 4
        },
        {
          :id                      => 'i3.16xlarge',
          :name                    => 'I3 Sixteen Extra Large',
          :bits                    => 64,
          :cores                   => 64,
          :disk                    => 15200,
          :ram                     => 523986,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 8
        },
        {
          :id                      => "r3.large",
          :name                    => "R3 Large",
          :bits                    => 64,
          :cores                   => 2,
          :ram                     => 16374,
          :disk                    => 32,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 1
        },
        {
          :id                      => "r3.xlarge",
          :name                    => "R3 Extra Large",
          :bits                    => 64,
          :cores                   => 4,
          :ram                     => 32749,
          :disk                    => 80,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => "r3.2xlarge",
          :name                    => "R3 Double Extra Large",
          :bits                    => 64,
          :cores                   => 8,
          :ram                     => 65498,
          :disk                    => 160,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => "r3.4xlarge",
          :name                    => "R3 Quadruple Extra Large",
          :bits                    => 64,
          :cores                   => 16,
          :ram                     => 130996,
          :disk                    => 320,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => "r3.8xlarge",
          :name                    => "R3 Eight Extra Large",
          :bits                    => 64,
          :cores                   => 32,
          :ram                     => 261993,
          :disk                    => 640,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 2
        },
        {
          :id                      => "r4.large",
          :name                    => "R4 Large",
          :bits                    => 64,
          :cores                   => 2,
          :ram                     => 16374,
          :disk                    => 0,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => "r4.xlarge",
          :name                    => "R4 Extra Large",
          :bits                    => 64,
          :cores                   => 4,
          :ram                     => 32749,
          :disk                    => 0,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => "r4.2xlarge",
          :name                    => "R4 Double Extra Large",
          :bits                    => 64,
          :cores                   => 8,
          :ram                     => 65498,
          :disk                    => 0,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => "r4.4xlarge",
          :name                    => "R4 Quadruple Extra Large",
          :bits                    => 64,
          :cores                   => 16,
          :ram                     => 130996,
          :disk                    => 0,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => "r4.8xlarge",
          :name                    => "R4 Eight Extra Large",
          :bits                    => 64,
          :cores                   => 32,
          :ram                     => 261993,
          :disk                    => 0,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => "r4.16xlarge",
          :name                    => "R4 Sixteen Extra Large",
          :bits                    => 64,
          :cores                   => 64,
          :ram                     => 523986,
          :disk                    => 0,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => "d2.xlarge",
          :name                    => "D2 Extra Large",
          :bits                    => 64,
          :cores                   => 4,
          :ram                     => 32749,
          :disk                    => 6000,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 3
        },
        {
          :id                      => "d2.2xlarge",
          :name                    => "D2 Double Extra Large",
          :bits                    => 64,
          :cores                   => 8,
          :ram                     => 65498,
          :disk                    => 12000,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 6
        },
        {
          :id                      => "d2.4xlarge",
          :name                    => "D2 Quadruple Extra Large",
          :bits                    => 64,
          :cores                   => 16,
          :ram                     => 130996,
          :disk                    => 24000,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 12
        },
        {
          :id                      => "d2.8xlarge",
          :name                    => "D2 Eight Extra Large",
          :bits                    => 64,
          :cores                   => 36,
          :ram                     => 261993,
          :disk                    => 48000,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 24
        },
        {
          :id                      => "m4.large",
          :name                    => "M4 Large",
          :bits                    => 64,
          :cores                   => 2,
          :ram                     => 8589,
          :disk                    => 0,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => "m4.xlarge",
          :name                    => "M4 Extra Large",
          :bits                    => 64,
          :cores                   => 4,
          :ram                     => 17179,
          :disk                    => 0,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => "m4.2xlarge",
          :name                    => "M4 Double Extra Large",
          :bits                    => 64,
          :cores                   => 8,
          :ram                     => 34359,
          :disk                    => 0,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => "m4.4xlarge",
          :name                    => "M4 Quadruple Extra Large",
          :bits                    => 64,
          :cores                   => 16,
          :ram                     => 68719,
          :disk                    => 0,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => "m4.10xlarge",
          :name                    => "M4 Ten Extra Large",
          :bits                    => 64,
          :cores                   => 40,
          :ram                     => 171798,
          :disk                    => 0,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => "m5.large",
          :name                    => "M5 Large",
          :bits                    => 64,
          :cores                   => 2,
          :ram                     => 8589,
          :disk                    => 0,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => "m5.xlarge",
          :name                    => "M5 Extra Large",
          :bits                    => 64,
          :cores                   => 4,
          :ram                     => 17179,
          :disk                    => 0,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => "m5.2xlarge",
          :name                    => "M5 Double Extra Large",
          :bits                    => 64,
          :cores                   => 8,
          :ram                     => 34359,
          :disk                    => 0,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => "m5.4xlarge",
          :name                    => "M5 Quadruple Extra Large",
          :bits                    => 64,
          :cores                   => 16,
          :ram                     => 68719,
          :disk                    => 0,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => "m5.12xlarge",
          :name                    => "M5 Twelve Extra Large",
          :bits                    => 64,
          :cores                   => 48,
          :ram                     => 206158,
          :disk                    => 0,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => "m5.24xlarge",
          :name                    => "M5 Twenty Four Extra Large",
          :bits                    => 64,
          :cores                   => 96,
          :ram                     => 412316,
          :disk                    => 0,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => "p2.xlarge",
          :name                    => "General Purpose GPU Extra Large",
          :bits                    => 64,
          :cores                   => 4,
          :ram                     => 65498,
          :disk                    => 0,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => "p2.8xlarge",
          :name                    => "General Purpose GPU Eight Extra Large",
          :bits                    => 64,
          :cores                   => 32,
          :ram                     => 523986,
          :disk                    => 0,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => "p2.16xlarge",
          :name                    => "General Purpose GPU Sixteen Extra Large",
          :bits                    => 64,
          :cores                   => 64,
          :ram                     => 785979,
          :disk                    => 0,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => "p3.2xlarge",
          :name                    => "Tesla GPU Two Extra Large",
          :bits                    => 64,
          :cores                   => 8,
          :ram                     => 65498,
          :disk                    => 0,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => "p3.8xlarge",
          :name                    => "Tesla GPU Eight Extra Large",
          :bits                    => 64,
          :cores                   => 32,
          :ram                     => 261993,
          :disk                    => 0,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => "p3.16xlarge",
          :name                    => "Tesla GPU Sixteen Extra Large",
          :bits                    => 64,
          :cores                   => 64,
          :ram                     => 523986,
          :disk                    => 0,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'g3.4xlarge',
          :name                    => 'G3 Quadruple Extra Large',
          :bits                    => 64,
          :cores                   => 16,
          :disk                    => 0,
          :ram                     => 130996,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'g3.8xlarge',
          :name                    => 'G3 Octuple Extra Large',
          :bits                    => 64,
          :cores                   => 32,
          :disk                    => 0,
          :ram                     => 261993,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'g3.16xlarge',
          :name                    => 'G3 Sixteen Extra Large',
          :bits                    => 64,
          :cores                   => 64,
          :disk                    => 0,
          :ram                     => 523986,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        }
      ]

      class Flavors < Fog::Collection
        model Fog::AWS::Compute::Flavor

        # Returns an array of all flavors that have been created
        #
        # AWS.flavors.all
        #
        # ==== Returns
        #
        # Returns an array of all available instances and their general information
        #
        #>> AWS.flavors.all
        #  <Fog::AWS::Compute::Flavors
        #    [
        #      <Fog::AWS::Compute::Flavor
        #        id="t1.micro",
        #        bits=0,
        #        cores=2,
        #        disk=0,
        #        name="Micro Instance",
        #        ram=613,
        #        ebs_optimized_available=false,
        #        instance_store_volumes=0
        #      >,
        #      <Fog::AWS::Compute::Flavor
        #        id="m1.small",
        #        bits=32,
        #        cores=1,
        #        disk=160,
        #        name="Small Instance",
        #        ram=1740.8,
        #        ebs_optimized_available=false,
        #        instance_store_volumes=1
        #      >,
        #      <Fog::AWS::Compute::Flavor
        #        id="m1.medium",
        #        bits=32,
        #        cores=2,
        #        disk=400,
        #        name="Medium Instance",
        #        ram=3750,
        #        ebs_optimized_available=false,
        #        instance_store_volumes=1
        #      >,
        #      <Fog::AWS::Compute::Flavor
        #        id="m1.large",
        #        bits=64,
        #        cores=4,
        #        disk=850,
        #        name="Large Instance",
        #        ram=7680,
        #        ebs_optimized_available=true
        #        instance_store_volumes=2
        #      >,
        #      <Fog::AWS::Compute::Flavor
        #        id="m1.xlarge",
        #        bits=64,
        #        cores=8,
        #        disk=1690,
        #        name="Extra Large Instance",
        #        ram=15360,
        #        ebs_optimized_available=true,
        #        instance_store_volumes=4
        #
        #      >,
        #      <Fog::AWS::Compute::Flavor
        #        id="c1.medium",
        #        bits=32,
        #        cores=5,
        #        disk=350,
        #        name="High-CPU Medium",
        #        ram=1740.8,
        #        ebs_optimized_available=false,
        #        instance_store_volumes=1
        #      >,
        #      <Fog::AWS::Compute::Flavor
        #        id="c1.xlarge",
        #        bits=64,
        #        cores=20,
        #        disk=1690,
        #        name="High-CPU Extra Large",
        #        ram=7168,
        #        ebs_optimized_available=true,
        #        instance_store_volumes=4
        #      >,
        #      <Fog::AWS::Compute::Flavor
        #        id="m2.xlarge",
        #        bits=64,
        #        cores=6.5,
        #        disk=420,
        #        name="High-Memory Extra Large",
        #        ram=17510.4,
        #        ebs_optimized_available=false,
        #        instance_store_volumes=1
        #      >,
        #      <Fog::AWS::Compute::Flavor
        #        id="m2.2xlarge",
        #        bits=64,
        #        cores=13,
        #        disk=850,
        #        name="High Memory Double Extra Large",
        #        ram=35020.8,
        #        ebs_optimized_available=true,
        #        instance_store_volumes=1
        #      >,
        #      <Fog::AWS::Compute::Flavor
        #        id="m2.4xlarge",
        #        bits=64,
        #        cores=26,
        #        disk=1690,
        #        name="High Memory Quadruple Extra Large",
        #        ram=70041.6,
        #        ebs_optimized_available=true,
        #        instance_store_volumes=2
        #      >,
        #      <Fog::AWS::Compute::Flavor
        #        id="cc1.4xlarge",
        #        bits=64,
        #        cores=33.5,
        #        disk=1690,
        #        name="Cluster Compute Quadruple Extra Large",
        #        ram=23552,
        #        ebs_optimized_available=false,
        #        instance_store_volumes=0
        #      >,
        #      <Fog::AWS::Compute::Flavor
        #        id="m3.xlarge",
        #        bits=64,
        #        cores=13,
        #        disk=0,
        #        name="M3 Extra Large",
        #        ram=15360,
        #        ebs_optimized_available=true,
        #        instance_store_volumes=2
        #      >,
        #      <Fog::AWS::Compute::Flavor
        #        id="m3.2xlarge",
        #        bits=64,
        #        cores=26,
        #        disk=0,
        #        name="M3 Double Extra Large",
        #        ram=30720,
        #        ebs_optimized_available=true,
        #        instance_store_volumes=2
        #      >,
        #      <Fog::AWS::Compute::Flavor
        #        id="cc2.8xlarge",
        #        bits=64,
        #        cores=88,
        #        disk=3370,
        #        name="Cluster Compute Eight Extra Large",
        #        ram=61952,
        #        ebs_optimized_available=false,
        #        instance_store_volumes=4
        #      >,
        #      <Fog::AWS::Compute::Flavor
        #        id="cg1.4xlarge",
        #        bits=64,
        #        cores=33.5,
        #        disk=1690,
        #        name="Cluster GPU Quadruple Extra Large",
        #        ram=22528,
        #        ebs_optimized_available=false,
        #        instance_store_volumes=2
        #      >
        #    ]
        #  >
        #

        def all
          load(Fog::AWS::Compute::FLAVORS)
          self
        end

        # Used to retrieve a flavor
        # flavor_id is required to get the associated flavor information.
        # flavors available currently:
        #
        # t1.micro
        # m1.small, m1.medium, m1.large, m1.xlarge
        # c1.medium, c1.xlarge
        # c3.large, c3.xlarge, c3.2xlarge, c3.4xlarge, c3.8xlarge
        # g2.2xlarge
        # hs1.8xlarge
        # m2.xlarge, m2.2xlarge, m2.4xlarge
        # m3.xlarge, m3.2xlarge
        # cr1.8xlarge
        # cc1.4xlarge
        # cc2.8xlarge
        # cg1.4xlarge
        # i2.xlarge, i2.2xlarge, i2.4xlarge, i2.8xlarge
        #
        # You can run the following command to get the details:
        # AWS.flavors.get("t1.micro")
        #
        # ==== Returns
        #
        #>> AWS.flavors.get("t1.micro")
        # <Fog::AWS::Compute::Flavor
        #  id="t1.micro",
        #  bits=0,
        #  cores=2,
        #  disk=0,
        #  name="Micro Instance",
        #  ram=613
        #  ebs_optimized_available=false
        #  instance_store_volumes=0
        #>
        #

        def get(flavor_id)
          self.class.new(:service => service).all.find {|flavor| flavor.id == flavor_id}
        end
      end
    end
  end
end
