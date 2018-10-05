require 'fog/aws/models/compute/flavor'

module Fog
  module AWS
    class Compute
      FLAVORS = [
        {
          :id                      => 'c1.medium',
          :name                    => 'C1 High-CPU Medium',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 350,
          :ram                     => 1825,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'c1.xlarge',
          :name                    => 'C1 High-CPU Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 420,
          :ram                     => 7516,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 4
        },
        {
          :id                      => 'c3.2xlarge',
          :name                    => 'C3 High-CPU Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 80,
          :ram                     => 16106,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'c3.4xlarge',
          :name                    => 'C3 High-CPU Quadruple Extra Large',
          :bits                    => 64,
          :cores                   => 16,
          :disk                    => 160,
          :ram                     => 32212,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'c3.8xlarge',
          :name                    => 'C3 High-CPU Eight Extra Large',
          :bits                    => 64,
          :cores                   => 32,
          :disk                    => 320,
          :ram                     => 64424,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'c3.large',
          :name                    => 'C3 High-CPU Large',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 16,
          :ram                     => 4026,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'c3.xlarge',
          :name                    => 'C3 High-CPU Extra Large',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 40,
          :ram                     => 8053,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'c4.2xlarge',
          :name                    => 'C4 High-CPU Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 0,
          :ram                     => 16106,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'c4.4xlarge',
          :name                    => 'C4 High-CPU Quadruple Extra Large',
          :bits                    => 64,
          :cores                   => 16,
          :disk                    => 0,
          :ram                     => 32212,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'c4.8xlarge',
          :name                    => 'C4 High-CPU Eight Extra Large',
          :bits                    => 64,
          :cores                   => 36,
          :disk                    => 0,
          :ram                     => 64424,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'c4.large',
          :name                    => 'C4 High-CPU Large',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 0,
          :ram                     => 4026,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'c4.xlarge',
          :name                    => 'C4 High-CPU Extra Large',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 0,
          :ram                     => 8053,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'c5.18xlarge',
          :name                    => 'C5 High-CPU 18xlarge',
          :bits                    => 64,
          :cores                   => 72,
          :disk                    => 0,
          :ram                     => 154618,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'c5.2xlarge',
          :name                    => 'C5 High-CPU Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 0,
          :ram                     => 17179,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'c5.4xlarge',
          :name                    => 'C5 High-CPU Quadruple Extra Large',
          :bits                    => 64,
          :cores                   => 16,
          :disk                    => 0,
          :ram                     => 34359,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'c5.9xlarge',
          :name                    => 'C5 High-CPU 9xlarge',
          :bits                    => 64,
          :cores                   => 36,
          :disk                    => 0,
          :ram                     => 77309,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'c5.large',
          :name                    => 'C5 High-CPU Large',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 0,
          :ram                     => 4294,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'c5.xlarge',
          :name                    => 'C5 High-CPU Extra Large',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 0,
          :ram                     => 8589,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'c5d.18xlarge',
          :name                    => 'C5 High-CPU 18xlarge',
          :bits                    => 64,
          :cores                   => 72,
          :disk                    => 900,
          :ram                     => 154618,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'c5d.2xlarge',
          :name                    => 'C5 High-CPU Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 200,
          :ram                     => 17179,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'c5d.4xlarge',
          :name                    => 'C5 High-CPU Quadruple Extra Large',
          :bits                    => 64,
          :cores                   => 16,
          :disk                    => 400,
          :ram                     => 34359,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'c5d.9xlarge',
          :name                    => 'C5 High-CPU 9xlarge',
          :bits                    => 64,
          :cores                   => 36,
          :disk                    => 900,
          :ram                     => 77309,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'c5d.large',
          :name                    => 'C5 High-CPU Large',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 50,
          :ram                     => 4294,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'c5d.xlarge',
          :name                    => 'C5 High-CPU Extra Large',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 100,
          :ram                     => 8589,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'cc2.8xlarge',
          :name                    => 'Cluster Compute Eight Extra Large',
          :bits                    => 64,
          :cores                   => 32,
          :disk                    => 840,
          :ram                     => 64961,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 4
        },
        {
          :id                      => 'cr1.8xlarge',
          :name                    => 'High Memory Cluster Eight Extra Large',
          :bits                    => 64,
          :cores                   => 32,
          :disk                    => 120,
          :ram                     => 261993,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'd2.2xlarge',
          :name                    => 'D2 Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 2000,
          :ram                     => 65498,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 6
        },
        {
          :id                      => 'd2.4xlarge',
          :name                    => 'D2 Quadruple Extra Large',
          :bits                    => 64,
          :cores                   => 16,
          :disk                    => 2000,
          :ram                     => 130996,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 12
        },
        {
          :id                      => 'd2.8xlarge',
          :name                    => 'D2 Eight Extra Large',
          :bits                    => 64,
          :cores                   => 36,
          :disk                    => 2000,
          :ram                     => 261993,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 24
        },
        {
          :id                      => 'd2.xlarge',
          :name                    => 'D2 Extra Large',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 2000,
          :ram                     => 32749,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 3
        },
        {
          :id                      => 'f1.16xlarge',
          :name                    => 'F1 16xlarge',
          :bits                    => 64,
          :cores                   => 64,
          :disk                    => 940,
          :ram                     => 1047972,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 4
        },
        {
          :id                      => 'f1.2xlarge',
          :name                    => 'F1 Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 470,
          :ram                     => 130996,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'f1.4xlarge',
          :name                    => 'F1 Quadruple Extra Large',
          :bits                    => 64,
          :cores                   => 16,
          :disk                    => 940,
          :ram                     => 261993,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'g2.2xlarge',
          :name                    => 'G2 Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 60,
          :ram                     => 16106,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'g2.8xlarge',
          :name                    => 'G2 Eight Extra Large',
          :bits                    => 64,
          :cores                   => 32,
          :disk                    => 120,
          :ram                     => 64424,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'g3.16xlarge',
          :name                    => 'G3 16xlarge',
          :bits                    => 64,
          :cores                   => 64,
          :disk                    => 0,
          :ram                     => 523986,
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
          :name                    => 'G3 Eight Extra Large',
          :bits                    => 64,
          :cores                   => 32,
          :disk                    => 0,
          :ram                     => 261993,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'h1.16xlarge',
          :name                    => 'H1 16xlarge',
          :bits                    => 64,
          :cores                   => 64,
          :disk                    => 2000,
          :ram                     => 274877,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 8
        },
        {
          :id                      => 'h1.2xlarge',
          :name                    => 'H1 Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 2000,
          :ram                     => 34359,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'h1.4xlarge',
          :name                    => 'H1 Quadruple Extra Large',
          :bits                    => 64,
          :cores                   => 16,
          :disk                    => 2000,
          :ram                     => 68719,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'h1.8xlarge',
          :name                    => 'H1 Eight Extra Large',
          :bits                    => 64,
          :cores                   => 32,
          :disk                    => 2000,
          :ram                     => 137438,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 4
        },
        {
          :id                      => 'hs1.8xlarge',
          :name                    => 'High Storage Eight Extra Large',
          :bits                    => 64,
          :cores                   => 16,
          :disk                    => 2000,
          :ram                     => 125627,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 24
        },
        {
          :id                      => 'i2.2xlarge',
          :name                    => 'I2 Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 800,
          :ram                     => 65498,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'i2.4xlarge',
          :name                    => 'I2 Quadruple Extra Large',
          :bits                    => 64,
          :cores                   => 16,
          :disk                    => 800,
          :ram                     => 130996,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 4
        },
        {
          :id                      => 'i2.8xlarge',
          :name                    => 'I2 Eight Extra Large',
          :bits                    => 64,
          :cores                   => 32,
          :disk                    => 800,
          :ram                     => 261993,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 8
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
          :id                      => 'i3.16xlarge',
          :name                    => 'I3 High I/O 16xlarge',
          :bits                    => 64,
          :cores                   => 64,
          :disk                    => 1900,
          :ram                     => 523986,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 8
        },
        {
          :id                      => 'i3.2xlarge',
          :name                    => 'I3 High I/O Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 1900,
          :ram                     => 65498,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'i3.4xlarge',
          :name                    => 'I3 High I/O Quadruple Extra Large',
          :bits                    => 64,
          :cores                   => 16,
          :disk                    => 1900,
          :ram                     => 130996,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'i3.8xlarge',
          :name                    => 'I3 High I/O Eight Extra Large',
          :bits                    => 64,
          :cores                   => 32,
          :disk                    => 1900,
          :ram                     => 261993,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 4
        },
        {
          :id                      => 'i3.large',
          :name                    => 'I3 High I/O Large',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 475,
          :ram                     => 16374,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'i3.xlarge',
          :name                    => 'I3 High I/O Extra Large',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 950,
          :ram                     => 32749,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'm1.large',
          :name                    => 'M1 General Purpose Large',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 420,
          :ram                     => 8053,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'm1.medium',
          :name                    => 'M1 General Purpose Medium',
          :bits                    => 64,
          :cores                   => 1,
          :disk                    => 410,
          :ram                     => 4026,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'm1.small',
          :name                    => 'M1 General Purpose Small',
          :bits                    => 64,
          :cores                   => 1,
          :disk                    => 160,
          :ram                     => 1825,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'm1.xlarge',
          :name                    => 'M1 General Purpose Extra Large',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 420,
          :ram                     => 16106,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 4
        },
        {
          :id                      => 'm2.2xlarge',
          :name                    => 'M2 High Memory Double Extra Large',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 850,
          :ram                     => 36721,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'm2.4xlarge',
          :name                    => 'M2 High Memory Quadruple Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 840,
          :ram                     => 73443,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'm2.xlarge',
          :name                    => 'M2 High Memory Extra Large',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 420,
          :ram                     => 18360,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'm3.2xlarge',
          :name                    => 'M3 General Purpose Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 80,
          :ram                     => 32212,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'm3.large',
          :name                    => 'M3 General Purpose Large',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 32,
          :ram                     => 8053,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'm3.medium',
          :name                    => 'M3 General Purpose Medium',
          :bits                    => 64,
          :cores                   => 1,
          :disk                    => 4,
          :ram                     => 4026,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'm3.xlarge',
          :name                    => 'M3 General Purpose Extra Large',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 40,
          :ram                     => 16106,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'm4.10xlarge',
          :name                    => 'M4 General Purpose Deca Extra Large',
          :bits                    => 64,
          :cores                   => 40,
          :disk                    => 0,
          :ram                     => 171798,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'm4.16xlarge',
          :name                    => 'M4 General Purpose 16xlarge',
          :bits                    => 64,
          :cores                   => 64,
          :disk                    => 0,
          :ram                     => 274877,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'm4.2xlarge',
          :name                    => 'M4 General Purpose Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 0,
          :ram                     => 34359,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'm4.4xlarge',
          :name                    => 'M4 General Purpose Quadruple Extra Large',
          :bits                    => 64,
          :cores                   => 16,
          :disk                    => 0,
          :ram                     => 68719,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'm4.large',
          :name                    => 'M4 General Purpose Large',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 0,
          :ram                     => 8589,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'm4.xlarge',
          :name                    => 'M4 General Purpose Extra Large',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 0,
          :ram                     => 17179,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'm5.12xlarge',
          :name                    => 'M5 General Purpose 12xlarge',
          :bits                    => 64,
          :cores                   => 48,
          :disk                    => 0,
          :ram                     => 206158,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'm5.24xlarge',
          :name                    => 'M5 General Purpose 24xlarge',
          :bits                    => 64,
          :cores                   => 96,
          :disk                    => 0,
          :ram                     => 412316,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'm5.2xlarge',
          :name                    => 'M5 General Purpose Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 0,
          :ram                     => 34359,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'm5.4xlarge',
          :name                    => 'M5 General Purpose Quadruple Extra Large',
          :bits                    => 64,
          :cores                   => 16,
          :disk                    => 0,
          :ram                     => 68719,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'm5.large',
          :name                    => 'M5 General Purpose Large',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 0,
          :ram                     => 8589,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'm5.xlarge',
          :name                    => 'M5 General Purpose Extra Large',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 0,
          :ram                     => 17179,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'm5d.12xlarge',
          :name                    => 'M5 General Purpose 12xlarge',
          :bits                    => 64,
          :cores                   => 48,
          :disk                    => 900,
          :ram                     => 206158,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'm5d.24xlarge',
          :name                    => 'M5 General Purpose 24xlarge',
          :bits                    => 64,
          :cores                   => 96,
          :disk                    => 900,
          :ram                     => 412316,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 4
        },
        {
          :id                      => 'm5d.2xlarge',
          :name                    => 'M5 General Purpose Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 300,
          :ram                     => 34359,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'm5d.4xlarge',
          :name                    => 'M5 General Purpose Quadruple Extra Large',
          :bits                    => 64,
          :cores                   => 16,
          :disk                    => 300,
          :ram                     => 68719,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'm5d.large',
          :name                    => 'M5 General Purpose Large',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 75,
          :ram                     => 8589,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'm5d.xlarge',
          :name                    => 'M5 General Purpose Extra Large',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 150,
          :ram                     => 17179,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'p2.16xlarge',
          :name                    => 'General Purpose GPU 16xlarge',
          :bits                    => 64,
          :cores                   => 64,
          :disk                    => 0,
          :ram                     => 785979,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'p2.8xlarge',
          :name                    => 'General Purpose GPU Eight Extra Large',
          :bits                    => 64,
          :cores                   => 32,
          :disk                    => 0,
          :ram                     => 523986,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'p2.xlarge',
          :name                    => 'General Purpose GPU Extra Large',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 0,
          :ram                     => 65498,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'p3.16xlarge',
          :name                    => 'P3 16xlarge',
          :bits                    => 64,
          :cores                   => 64,
          :disk                    => 0,
          :ram                     => 523986,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'p3.2xlarge',
          :name                    => 'P3 Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 0,
          :ram                     => 65498,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'p3.8xlarge',
          :name                    => 'P3 Eight Extra Large',
          :bits                    => 64,
          :cores                   => 32,
          :disk                    => 0,
          :ram                     => 261993,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'r3.2xlarge',
          :name                    => 'R3 High-Memory Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 160,
          :ram                     => 65498,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'r3.4xlarge',
          :name                    => 'R3 High-Memory Quadruple Extra Large',
          :bits                    => 64,
          :cores                   => 16,
          :disk                    => 320,
          :ram                     => 130996,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'r3.8xlarge',
          :name                    => 'R3 High-Memory Eight Extra Large',
          :bits                    => 64,
          :cores                   => 32,
          :disk                    => 320,
          :ram                     => 261993,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'r3.large',
          :name                    => 'R3 High-Memory Large',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 32,
          :ram                     => 16374,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'r3.xlarge',
          :name                    => 'R3 High-Memory Extra Large',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 80,
          :ram                     => 32749,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'r4.16xlarge',
          :name                    => 'R4 High-Memory 16xlarge',
          :bits                    => 64,
          :cores                   => 64,
          :disk                    => 0,
          :ram                     => 523986,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'r4.2xlarge',
          :name                    => 'R4 High-Memory Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 0,
          :ram                     => 65498,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'r4.4xlarge',
          :name                    => 'R4 High-Memory Quadruple Extra Large',
          :bits                    => 64,
          :cores                   => 16,
          :disk                    => 0,
          :ram                     => 130996,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'r4.8xlarge',
          :name                    => 'R4 High-Memory Eight Extra Large',
          :bits                    => 64,
          :cores                   => 32,
          :disk                    => 0,
          :ram                     => 261993,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'r4.large',
          :name                    => 'R4 High-Memory Large',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 0,
          :ram                     => 16374,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'r4.xlarge',
          :name                    => 'R4 High-Memory Extra Large',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 0,
          :ram                     => 32749,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'r5.12xlarge',
          :name                    => 'R5 12xlarge',
          :bits                    => 64,
          :cores                   => 48,
          :disk                    => 0,
          :ram                     => 412316,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'r5.24xlarge',
          :name                    => 'R5 24xlarge',
          :bits                    => 64,
          :cores                   => 96,
          :disk                    => 0,
          :ram                     => 824633,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'r5.2xlarge',
          :name                    => 'R5 Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 0,
          :ram                     => 68719,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'r5.4xlarge',
          :name                    => 'R5 Quadruple Extra Large',
          :bits                    => 64,
          :cores                   => 16,
          :disk                    => 0,
          :ram                     => 137438,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'r5.large',
          :name                    => 'R5 Large',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 0,
          :ram                     => 17179,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'r5.xlarge',
          :name                    => 'R5 Extra Large',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 0,
          :ram                     => 34359,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'r5d.12xlarge',
          :name                    => 'R5D 12xlarge',
          :bits                    => 64,
          :cores                   => 48,
          :disk                    => 900,
          :ram                     => 412316,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'r5d.24xlarge',
          :name                    => 'R5D 24xlarge',
          :bits                    => 64,
          :cores                   => 96,
          :disk                    => 900,
          :ram                     => 824633,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 4
        },
        {
          :id                      => 'r5d.2xlarge',
          :name                    => 'R5D Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 300,
          :ram                     => 68719,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'r5d.4xlarge',
          :name                    => 'R5D Quadruple Extra Large',
          :bits                    => 64,
          :cores                   => 16,
          :disk                    => 300,
          :ram                     => 137438,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'r5d.large',
          :name                    => 'R5D Large',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 75,
          :ram                     => 17179,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'r5d.xlarge',
          :name                    => 'R5D Extra Large',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 150,
          :ram                     => 34359,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 't1.micro',
          :name                    => 'T1 Micro',
          :bits                    => 64,
          :cores                   => 1,
          :disk                    => 0,
          :ram                     => 658,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 't2.2xlarge',
          :name                    => 'T2 Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 0,
          :ram                     => 34359,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 't2.large',
          :name                    => 'T2 Large',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 0,
          :ram                     => 8589,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 't2.medium',
          :name                    => 'T2 Medium',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 0,
          :ram                     => 4294,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 't2.micro',
          :name                    => 'T2 Micro',
          :bits                    => 64,
          :cores                   => 1,
          :disk                    => 0,
          :ram                     => 1073,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 't2.nano',
          :name                    => 'T2 Nano',
          :bits                    => 64,
          :cores                   => 1,
          :disk                    => 0,
          :ram                     => 536,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 't2.small',
          :name                    => 'T2 Small',
          :bits                    => 64,
          :cores                   => 1,
          :disk                    => 0,
          :ram                     => 2147,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 't2.xlarge',
          :name                    => 'T2 Extra Large',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 0,
          :ram                     => 17179,
          :ebs_optimized_available => false,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 't3.2xlarge',
          :name                    => 'T3 Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 0,
          :ram                     => 34359,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 't3.large',
          :name                    => 'T3 Large',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 0,
          :ram                     => 8589,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 't3.medium',
          :name                    => 'T3 Medium',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 0,
          :ram                     => 4294,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 't3.micro',
          :name                    => 'T3 Micro',
          :bits                    => 64,
          :cores                   => 1,
          :disk                    => 0,
          :ram                     => 1073,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 't3.nano',
          :name                    => 'T3 Nano',
          :bits                    => 64,
          :cores                   => 1,
          :disk                    => 0,
          :ram                     => 536,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 't3.small',
          :name                    => 'T3 Small',
          :bits                    => 64,
          :cores                   => 1,
          :disk                    => 0,
          :ram                     => 2147,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 't3.xlarge',
          :name                    => 'T3 Extra Large',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 0,
          :ram                     => 17179,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'u-12tb1.metal',
          :name                    => 'U-12TB1 Metal',
          :bits                    => 64,
          :cores                   => 448,
          :disk                    => 0,
          :ram                     => 13194139,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'u-6tb1.metal',
          :name                    => 'U-6TB1 Metal',
          :bits                    => 64,
          :cores                   => 448,
          :disk                    => 0,
          :ram                     => 6597069,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'u-9tb1.metal',
          :name                    => 'U-9TB1 Metal',
          :bits                    => 64,
          :cores                   => 448,
          :disk                    => 0,
          :ram                     => 9895604,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 0
        },
        {
          :id                      => 'x1.16xlarge',
          :name                    => 'X1 Extra High-Memory 16xlarge',
          :bits                    => 64,
          :cores                   => 64,
          :disk                    => 1920,
          :ram                     => 1047972,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'x1.32xlarge',
          :name                    => 'X1 Extra High-Memory 32xlarge',
          :bits                    => 64,
          :cores                   => 128,
          :disk                    => 1920,
          :ram                     => 2095944,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'x1e.16xlarge',
          :name                    => 'X1E 16xlarge',
          :bits                    => 64,
          :cores                   => 64,
          :disk                    => 1920,
          :ram                     => 2095944,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'x1e.2xlarge',
          :name                    => 'X1E Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 240,
          :ram                     => 261993,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'x1e.32xlarge',
          :name                    => 'X1E 32xlarge',
          :bits                    => 64,
          :cores                   => 128,
          :disk                    => 1920,
          :ram                     => 4191888,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'x1e.4xlarge',
          :name                    => 'X1E Quadruple Extra Large',
          :bits                    => 64,
          :cores                   => 16,
          :disk                    => 480,
          :ram                     => 523986,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'x1e.8xlarge',
          :name                    => 'X1E Eight Extra Large',
          :bits                    => 64,
          :cores                   => 32,
          :disk                    => 960,
          :ram                     => 1047972,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'x1e.xlarge',
          :name                    => 'X1E Extra Large',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 120,
          :ram                     => 130996,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'z1d.12xlarge',
          :name                    => 'Z1D 12xlarge',
          :bits                    => 64,
          :cores                   => 48,
          :disk                    => 900,
          :ram                     => 412316,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 2
        },
        {
          :id                      => 'z1d.2xlarge',
          :name                    => 'Z1D Double Extra Large',
          :bits                    => 64,
          :cores                   => 8,
          :disk                    => 300,
          :ram                     => 68719,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'z1d.3xlarge',
          :name                    => 'Z1D 3xlarge',
          :bits                    => 64,
          :cores                   => 12,
          :disk                    => 450,
          :ram                     => 103079,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'z1d.6xlarge',
          :name                    => 'Z1D 6xlarge',
          :bits                    => 64,
          :cores                   => 24,
          :disk                    => 900,
          :ram                     => 206158,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'z1d.large',
          :name                    => 'Z1D Large',
          :bits                    => 64,
          :cores                   => 2,
          :disk                    => 75,
          :ram                     => 17179,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
        },
        {
          :id                      => 'z1d.xlarge',
          :name                    => 'Z1D Extra Large',
          :bits                    => 64,
          :cores                   => 4,
          :disk                    => 150,
          :ram                     => 34359,
          :ebs_optimized_available => true,
          :instance_store_volumes  => 1
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
