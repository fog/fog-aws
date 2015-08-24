# Change Log

## [v0.7.5](https://github.com/fog/fog-aws/tree/v0.7.5) (2015-08-24)
[Full Changelog](https://github.com/fog/fog-aws/compare/v0.7.4...v0.7.5)

**Closed issues:**

- how to change filepath for html\_table\_reporter in reporter options [\#167](https://github.com/fog/fog-aws/issues/167)
- Access Key, etc still required for Storage access when using use\_iam\_profile [\#162](https://github.com/fog/fog-aws/issues/162)
- Support for KMS ID for EBS Volume [\#141](https://github.com/fog/fog-aws/issues/141)

**Merged pull requests:**

- validate rds server security group associations [\#173](https://github.com/fog/fog-aws/pull/173) ([lanej](https://github.com/lanej))
- format security groups when modifying db instance [\#171](https://github.com/fog/fog-aws/pull/171) ([michelleN](https://github.com/michelleN))
- standardize region validation [\#169](https://github.com/fog/fog-aws/pull/169) ([lanej](https://github.com/lanej))
- expose elb region [\#168](https://github.com/fog/fog-aws/pull/168) ([lanej](https://github.com/lanej))
- volume\#key\_id and encrypted tests [\#165](https://github.com/fog/fog-aws/pull/165) ([lanej](https://github.com/lanej))
- raise InvalidParameterCombination error [\#163](https://github.com/fog/fog-aws/pull/163) ([michelleN](https://github.com/michelleN))
- storage request bad xml schema for put bucket notification fix [\#161](https://github.com/fog/fog-aws/pull/161) ([bahchis](https://github.com/bahchis))
- Use regex instead of string matching to support redirect correctly when path\_style is set to true [\#159](https://github.com/fog/fog-aws/pull/159) ([drich10](https://github.com/drich10))
- update \#promote\_read\_replica mock [\#158](https://github.com/fog/fog-aws/pull/158) ([lanej](https://github.com/lanej))

## [v0.7.4](https://github.com/fog/fog-aws/tree/v0.7.4) (2015-07-30)
[Full Changelog](https://github.com/fog/fog-aws/compare/v0.7.3...v0.7.4)

**Merged pull requests:**

- AutoScaling attach/detach ELB support + tests [\#156](https://github.com/fog/fog-aws/pull/156) ([nbfowler](https://github.com/nbfowler))
- Route53 zone listing fix and support for private hosted zones [\#154](https://github.com/fog/fog-aws/pull/154) ([solud](https://github.com/solud))

## [v0.7.3](https://github.com/fog/fog-aws/tree/v0.7.3) (2015-07-10)
[Full Changelog](https://github.com/fog/fog-aws/compare/v0.7.2...v0.7.3)

**Closed issues:**

- "Error: The specified marker is not valid" after upgrade to 0.7.0 [\#148](https://github.com/fog/fog-aws/issues/148)

**Merged pull requests:**

- encrypted storage on rds [\#153](https://github.com/fog/fog-aws/pull/153) ([ehowe](https://github.com/ehowe))

## [v0.7.2](https://github.com/fog/fog-aws/tree/v0.7.2) (2015-07-08)
[Full Changelog](https://github.com/fog/fog-aws/compare/v0.7.1...v0.7.2)

**Fixed bugs:**

- NoMethodError trying to create a new AWS Route53 entry using version 0.7.1 [\#150](https://github.com/fog/fog-aws/issues/150)

**Merged pull requests:**

- fix \#change\_resource\_record\_sets [\#151](https://github.com/fog/fog-aws/pull/151) ([lanej](https://github.com/lanej))

## [v0.7.1](https://github.com/fog/fog-aws/tree/v0.7.1) (2015-07-08)
[Full Changelog](https://github.com/fog/fog-aws/compare/v0.7.0...v0.7.1)

**Merged pull requests:**

- Fix broken xmlns in DNS requests [\#149](https://github.com/fog/fog-aws/pull/149) ([decklin](https://github.com/decklin))
- Fix blank content-encoding headers [\#147](https://github.com/fog/fog-aws/pull/147) ([fcheung](https://github.com/fcheung))

## [v0.7.0](https://github.com/fog/fog-aws/tree/v0.7.0) (2015-07-07)
[Full Changelog](https://github.com/fog/fog-aws/compare/v0.6.0...v0.7.0)

**Closed issues:**

- Add support for AWS Lambda [\#124](https://github.com/fog/fog-aws/issues/124)

**Merged pull requests:**

- Describe vpcPeeringConnectionId [\#146](https://github.com/fog/fog-aws/pull/146) ([fdr](https://github.com/fdr))
- Adds isDefault to parser for describe\_vpcs [\#144](https://github.com/fog/fog-aws/pull/144) ([gregburek](https://github.com/gregburek))
- Support kinesis [\#143](https://github.com/fog/fog-aws/pull/143) ([mikehale](https://github.com/mikehale))
- The :geo\_location attribute needs to be xml formatted before calling aws [\#142](https://github.com/fog/fog-aws/pull/142) ([carloslima](https://github.com/carloslima))
- Escape Lambda function name in request paths [\#140](https://github.com/fog/fog-aws/pull/140) ([nomadium](https://github.com/nomadium))
- list\_hosted\_zones expects that options to be hash with symbol as key [\#139](https://github.com/fog/fog-aws/pull/139) ([slashmili](https://github.com/slashmili))

## [v0.6.0](https://github.com/fog/fog-aws/tree/v0.6.0) (2015-06-23)
[Full Changelog](https://github.com/fog/fog-aws/compare/v0.5.0...v0.6.0)

**Merged pull requests:**

- Add support for AWS Lambda service [\#123](https://github.com/fog/fog-aws/pull/123) ([nomadium](https://github.com/nomadium))

## [v0.5.0](https://github.com/fog/fog-aws/tree/v0.5.0) (2015-06-17)
[Full Changelog](https://github.com/fog/fog-aws/compare/v0.4.1...v0.5.0)

**Merged pull requests:**

- add t2.large [\#137](https://github.com/fog/fog-aws/pull/137) ([lanej](https://github.com/lanej))
- Make Mock create\_vpc method arity match Real [\#135](https://github.com/fog/fog-aws/pull/135) ([fdr](https://github.com/fdr))
- Add support for EC2 Container Service [\#120](https://github.com/fog/fog-aws/pull/120) ([nomadium](https://github.com/nomadium))

## [v0.4.1](https://github.com/fog/fog-aws/tree/v0.4.1) (2015-06-15)
[Full Changelog](https://github.com/fog/fog-aws/compare/v0.4.0...v0.4.1)

**Closed issues:**

- Fog doesn't support storage\_type or gp2 for RDS? [\#129](https://github.com/fog/fog-aws/issues/129)
- Fog-aws not working with Hitachi [\#122](https://github.com/fog/fog-aws/issues/122)
- "NoMethodError: undefined method `body' for \#\<Fog::DNS::AWS::Error:0x007f6c673e1720\>" [\#112](https://github.com/fog/fog-aws/issues/112)
- Add support for EC2 Container Service \(ECS\) [\#93](https://github.com/fog/fog-aws/issues/93)

**Merged pull requests:**

- Fix attributes of flavors [\#134](https://github.com/fog/fog-aws/pull/134) ([yumminhuang](https://github.com/yumminhuang))
- Fix S3 signature v4 signing [\#133](https://github.com/fog/fog-aws/pull/133) ([fcheung](https://github.com/fcheung))
- Add New M4 Instance Type [\#132](https://github.com/fog/fog-aws/pull/132) ([yumminhuang](https://github.com/yumminhuang))
- raise correct error when exceeding address limit [\#131](https://github.com/fog/fog-aws/pull/131) ([lanej](https://github.com/lanej))
- make elb/policies collection standalone [\#128](https://github.com/fog/fog-aws/pull/128) ([lanej](https://github.com/lanej))
- model managed policies [\#126](https://github.com/fog/fog-aws/pull/126) ([lanej](https://github.com/lanej))

## [v0.4.0](https://github.com/fog/fog-aws/tree/v0.4.0) (2015-05-27)
[Full Changelog](https://github.com/fog/fog-aws/compare/v0.3.0...v0.4.0)

**Merged pull requests:**

- model iam groups [\#121](https://github.com/fog/fog-aws/pull/121) ([lanej](https://github.com/lanej))

## [v0.3.0](https://github.com/fog/fog-aws/tree/v0.3.0) (2015-05-21)
[Full Changelog](https://github.com/fog/fog-aws/compare/v0.2.2...v0.3.0)

**Merged pull requests:**

- support iam/get\_user without username [\#114](https://github.com/fog/fog-aws/pull/114) ([lanej](https://github.com/lanej))
- Added a new request - describe\_instance\_attribute [\#110](https://github.com/fog/fog-aws/pull/110) ([nilroy](https://github.com/nilroy))

## [v0.2.2](https://github.com/fog/fog-aws/tree/v0.2.2) (2015-05-13)
[Full Changelog](https://github.com/fog/fog-aws/compare/v0.2.1...v0.2.2)

## [v0.2.1](https://github.com/fog/fog-aws/tree/v0.2.1) (2015-05-13)
[Full Changelog](https://github.com/fog/fog-aws/compare/v0.2.0...v0.2.1)

**Merged pull requests:**

- mocks for topic permissions [\#111](https://github.com/fog/fog-aws/pull/111) ([lanej](https://github.com/lanej))

## [v0.2.0](https://github.com/fog/fog-aws/tree/v0.2.0) (2015-05-13)
[Full Changelog](https://github.com/fog/fog-aws/compare/v0.1.2...v0.2.0)

**Closed issues:**

- IAM authentication not compatible with GovCloud  [\#100](https://github.com/fog/fog-aws/issues/100)
- Enabling termination protection [\#95](https://github.com/fog/fog-aws/issues/95)
- SSLv3 deprecation: action required? [\#88](https://github.com/fog/fog-aws/issues/88)

**Merged pull requests:**

- configure server attributes in mock [\#109](https://github.com/fog/fog-aws/pull/109) ([michelleN](https://github.com/michelleN))
- support aws kms [\#108](https://github.com/fog/fog-aws/pull/108) ([lanej](https://github.com/lanej))
- update RDS to 2014-10-31 version [\#107](https://github.com/fog/fog-aws/pull/107) ([lanej](https://github.com/lanej))
- Another attempt to solve content-encoding header issues [\#106](https://github.com/fog/fog-aws/pull/106) ([fcheung](https://github.com/fcheung))
- default replica AutoMinorVersionUpgrade to master [\#104](https://github.com/fog/fog-aws/pull/104) ([michelleN](https://github.com/michelleN))
- Refresh credentials if needed when signing S3 URL [\#103](https://github.com/fog/fog-aws/pull/103) ([matkam](https://github.com/matkam))
- Allow the IAM constructor to accept a region [\#102](https://github.com/fog/fog-aws/pull/102) ([benbalter](https://github.com/benbalter))
- configure auto\_minor\_version\_upgrade in mock [\#101](https://github.com/fog/fog-aws/pull/101) ([michelleN](https://github.com/michelleN))
- Adding instanceTenancy to reserved instance parser. [\#97](https://github.com/fog/fog-aws/pull/97) ([dmbrooking](https://github.com/dmbrooking))
- Parse elasticache configuration endpoint from response [\#96](https://github.com/fog/fog-aws/pull/96) ([fcheung](https://github.com/fcheung))
- Fix mock VPC ELB creation in regions other than us-east-1 [\#94](https://github.com/fog/fog-aws/pull/94) ([mrpoundsign](https://github.com/mrpoundsign))
- Fix repository URL in README.md [\#91](https://github.com/fog/fog-aws/pull/91) ([tricknotes](https://github.com/tricknotes))
- adding support for d2 instance type [\#90](https://github.com/fog/fog-aws/pull/90) ([yumminhuang](https://github.com/yumminhuang))
- Support weight round robin mock [\#89](https://github.com/fog/fog-aws/pull/89) ([freddy1666](https://github.com/freddy1666))
- Update README.md [\#87](https://github.com/fog/fog-aws/pull/87) ([nomadium](https://github.com/nomadium))
- Add mock for EC2 request\_spot\_instances API request [\#86](https://github.com/fog/fog-aws/pull/86) ([nomadium](https://github.com/nomadium))
- Move more requires to autoload [\#85](https://github.com/fog/fog-aws/pull/85) ([plribeiro3000](https://github.com/plribeiro3000))
- Add mock for EC2 describe\_spot\_price\_history API request [\#84](https://github.com/fog/fog-aws/pull/84) ([nomadium](https://github.com/nomadium))

## [v0.1.2](https://github.com/fog/fog-aws/tree/v0.1.2) (2015-04-07)
[Full Changelog](https://github.com/fog/fog-aws/compare/v0.1.1...v0.1.2)

**Closed issues:**

- Ruby warnings Comparable & Return nil  [\#81](https://github.com/fog/fog-aws/issues/81)
- CircleCI failing [\#80](https://github.com/fog/fog-aws/issues/80)
- Heroku error [\#77](https://github.com/fog/fog-aws/issues/77)
- Repeatable signed urls for the same expiry [\#65](https://github.com/fog/fog-aws/issues/65)

**Merged pull requests:**

- Handle missing parameters in describe\_spot\_price\_history request [\#82](https://github.com/fog/fog-aws/pull/82) ([nomadium](https://github.com/nomadium))
- create db instance in the correct region [\#79](https://github.com/fog/fog-aws/pull/79) ([lanej](https://github.com/lanej))
- Remove assignment within conditional in File\#body [\#78](https://github.com/fog/fog-aws/pull/78) ([greysteil](https://github.com/greysteil))
- mock DescribeDBEngineVersions [\#76](https://github.com/fog/fog-aws/pull/76) ([ehowe](https://github.com/ehowe))
- Fix blank content-encoding when none is supplied [\#75](https://github.com/fog/fog-aws/pull/75) ([fcheung](https://github.com/fcheung))
- \[rds\] prevent final snapshot on replicas [\#74](https://github.com/fog/fog-aws/pull/74) ([lanej](https://github.com/lanej))
- Fix for `undefined method `map' for nil:NilClass` [\#73](https://github.com/fog/fog-aws/pull/73) ([mattheworiordan](https://github.com/mattheworiordan))
- Resource record sets bug fix + support eu-central-1  [\#72](https://github.com/fog/fog-aws/pull/72) ([mattheworiordan](https://github.com/mattheworiordan))
- Fix EC2 security groups where SSH inbound rule isn't first [\#71](https://github.com/fog/fog-aws/pull/71) ([ayumi](https://github.com/ayumi))
- eu-central missing from Fog::Compute::AWS::Mock [\#70](https://github.com/fog/fog-aws/pull/70) ([wyhaines](https://github.com/wyhaines))
- Remove executable bit from files. [\#69](https://github.com/fog/fog-aws/pull/69) ([voxik](https://github.com/voxik))
- Remove Mac specific files. [\#68](https://github.com/fog/fog-aws/pull/68) ([voxik](https://github.com/voxik))
- Stringify keys for query parameters [\#67](https://github.com/fog/fog-aws/pull/67) ([jfmyers9](https://github.com/jfmyers9))
- Mock method for AWS S3 post\_object\_hidden\_fields  [\#63](https://github.com/fog/fog-aws/pull/63) ([byterussian](https://github.com/byterussian))
- Add support for cname buckets [\#61](https://github.com/fog/fog-aws/pull/61) ([dsgh](https://github.com/dsgh))

## [v0.1.1](https://github.com/fog/fog-aws/tree/v0.1.1) (2015-02-25)
[Full Changelog](https://github.com/fog/fog-aws/compare/v0.1.0...v0.1.1)

**Closed issues:**

- head\_url signed [\#47](https://github.com/fog/fog-aws/issues/47)
- AWS Credentials required when using IAM Profile [\#44](https://github.com/fog/fog-aws/issues/44)

**Merged pull requests:**

- Support for IAM managed policies [\#60](https://github.com/fog/fog-aws/pull/60) ([fcheung](https://github.com/fcheung))
- Fix for ScanFilter parameters [\#58](https://github.com/fog/fog-aws/pull/58) ([nawaidshamim](https://github.com/nawaidshamim))
- \[dns\] fix Records\#get, mock records and proper errors [\#57](https://github.com/fog/fog-aws/pull/57) ([lanej](https://github.com/lanej))
- \[aws|compute\] support c4.8xlarge flavor [\#56](https://github.com/fog/fog-aws/pull/56) ([ddoc](https://github.com/ddoc))
- \[aws|compute\] adding support for c4 instance class [\#55](https://github.com/fog/fog-aws/pull/55) ([ddoc](https://github.com/ddoc))
- not allowed to delete a "revoking" rds firewall [\#54](https://github.com/fog/fog-aws/pull/54) ([lanej](https://github.com/lanej))
- raise when destroying an ec2 firewall authorized to an rds firewall [\#53](https://github.com/fog/fog-aws/pull/53) ([lanej](https://github.com/lanej))
- Making it easier to get pre-signed head requests [\#51](https://github.com/fog/fog-aws/pull/51) ([mrloop](https://github.com/mrloop))
- Support customer encryption headers in multipart uploads [\#50](https://github.com/fog/fog-aws/pull/50) ([lautis](https://github.com/lautis))
- don't allow sg authorization to unknown sgs [\#49](https://github.com/fog/fog-aws/pull/49) ([lanej](https://github.com/lanej))

## [v0.1.0](https://github.com/fog/fog-aws/tree/v0.1.0) (2015-02-03)
[Full Changelog](https://github.com/fog/fog-aws/compare/v0.0.8...v0.1.0)

**Closed issues:**

- AWS Launch Configuration missing Ebs.Volume\_Type [\#18](https://github.com/fog/fog-aws/issues/18)

**Merged pull requests:**

- Fix v4 signature when path has repeated slashes in the middle [\#46](https://github.com/fog/fog-aws/pull/46) ([fcheung](https://github.com/fcheung))
- get signin token for federation [\#45](https://github.com/fog/fog-aws/pull/45) ([ehowe](https://github.com/ehowe))
- add 'volumeType' and 'encrypted' to blockDeviceMapping parser [\#43](https://github.com/fog/fog-aws/pull/43) ([ichii386](https://github.com/ichii386))
- default namespace and evaluation period on alarm [\#37](https://github.com/fog/fog-aws/pull/37) ([michelleN](https://github.com/michelleN))

## [v0.0.8](https://github.com/fog/fog-aws/tree/v0.0.8) (2015-01-27)
[Full Changelog](https://github.com/fog/fog-aws/compare/v0.0.7...v0.0.8)

**Closed issues:**

- NoMethodError - undefined method `signature\_parameters' for nil:NilClass [\#28](https://github.com/fog/fog-aws/issues/28)

**Merged pull requests:**

- add missing mocks [\#41](https://github.com/fog/fog-aws/pull/41) ([michelleN](https://github.com/michelleN))
- Add idempotent excon option to some route53 API calls [\#40](https://github.com/fog/fog-aws/pull/40) ([josacar](https://github.com/josacar))
- Allow for AWS errors not specifying region [\#39](https://github.com/fog/fog-aws/pull/39) ([greysteil](https://github.com/greysteil))
- correct engine version param on rds replicas [\#38](https://github.com/fog/fog-aws/pull/38) ([lanej](https://github.com/lanej))
- \[AWS|Autoscaling\] Add missing ebs attributes to describe\_launch\_configurations [\#35](https://github.com/fog/fog-aws/pull/35) ([fcheung](https://github.com/fcheung))
- \[AWS|Storage\] signed\_url should use v2 signature when aws\_signature\_version is 2 [\#34](https://github.com/fog/fog-aws/pull/34) ([fcheung](https://github.com/fcheung))
- BUGFIX: When fog\_credentials endpoint is set @region defaults to nil [\#33](https://github.com/fog/fog-aws/pull/33) ([nicholasklick](https://github.com/nicholasklick))
- \[AWS|Autoscaling\] Support classic link related properties for launch configurations [\#32](https://github.com/fog/fog-aws/pull/32) ([fcheung](https://github.com/fcheung))
- fix autoscaling activities collection setup [\#31](https://github.com/fog/fog-aws/pull/31) ([fcheung](https://github.com/fcheung))
- Add PlacementTenancy to launch configuration parser and test case [\#29](https://github.com/fog/fog-aws/pull/29) ([benpillet](https://github.com/benpillet))
- Use Fog::Formatador [\#27](https://github.com/fog/fog-aws/pull/27) ([starbelly](https://github.com/starbelly))

## [v0.0.7](https://github.com/fog/fog-aws/tree/v0.0.7) (2015-01-23)
[Full Changelog](https://github.com/fog/fog-aws/compare/v0.0.6...v0.0.7)

**Closed issues:**

- SSL Error on S3 connection [\#9](https://github.com/fog/fog-aws/issues/9)

**Merged pull requests:**

- simulate sns confirmation message [\#36](https://github.com/fog/fog-aws/pull/36) ([lanej](https://github.com/lanej))
- Support for VPC Classic Link [\#3](https://github.com/fog/fog-aws/pull/3) ([fcheung](https://github.com/fcheung))

## [v0.0.6](https://github.com/fog/fog-aws/tree/v0.0.6) (2015-01-12)
[Full Changelog](https://github.com/fog/fog-aws/compare/v0.0.5...v0.0.6)

**Closed issues:**

- missed files [\#1](https://github.com/fog/fog-aws/issues/1)

**Merged pull requests:**

- \[AWS|Core\] Fix signature v4 non canonicalising header case properly [\#4](https://github.com/fog/fog-aws/pull/4) ([fcheung](https://github.com/fcheung))
- another attempt at s3 region redirecting [\#2](https://github.com/fog/fog-aws/pull/2) ([geemus](https://github.com/geemus))

## [v0.0.5](https://github.com/fog/fog-aws/tree/v0.0.5) (2015-01-06)
[Full Changelog](https://github.com/fog/fog-aws/compare/v0.0.4...v0.0.5)

## [v0.0.4](https://github.com/fog/fog-aws/tree/v0.0.4) (2015-01-04)
[Full Changelog](https://github.com/fog/fog-aws/compare/v0.0.3...v0.0.4)

## [v0.0.3](https://github.com/fog/fog-aws/tree/v0.0.3) (2015-01-02)
[Full Changelog](https://github.com/fog/fog-aws/compare/v0.0.2...v0.0.3)

## [v0.0.2](https://github.com/fog/fog-aws/tree/v0.0.2) (2015-01-02)
[Full Changelog](https://github.com/fog/fog-aws/compare/v0.0.1...v0.0.2)

## [v0.0.1](https://github.com/fog/fog-aws/tree/v0.0.1) (2015-01-02)


\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*