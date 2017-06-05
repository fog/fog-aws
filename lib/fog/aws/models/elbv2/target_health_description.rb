module Fog
  module AWS
    class ELBV2
      class TargetHealthDescription < Fog::Model
        attribute :health_check_port, :aliases => 'HealthCheckPort'
        attribute :target, :aliases => 'Target'
        attribute :target_health, :aliases => 'TargetHealth'

        def target_id
          target['Id']
        end

        def description
          target_health['Description']
        end

        def state
          target_health['State']
        end

        def reason
          target_health['Reason']
        end

        def initial?
          state == 'initial'
        end

        def healthy?
          state == 'healthy'
        end

        def unhealthy?
          state == 'unhealthy'
        end

        def unused?
          state == 'unused'
        end

        def draining?
          state == 'draining'
        end

        def not_registered?
          unused? && reason == 'Target.NotRegistered'
        end

        def not_in_use?
          unused? && reason == 'Target.NotInUse'
        end

        def invalid_state?
          unused? && reason == 'Target.InvalidState'
        end

        def registration_in_progress?
          initial? && reason == 'Elb.RegistrationInProgress'
        end

        def deregistration_in_progress?
          draining? && reason == 'Target.DeregistrationInProgress'
        end

        def initial_health_checking?
          initial? && reason == 'Elb.InitialHealthChecking'
        end

        def response_code_mispatch?
          unhealthy? && reason == 'Target.ResponseCodeMismatch'
        end

        def timeout?
          unhealthy? && reason == 'Target.Timeout'
        end

        def failed_health_checks?
          unhealthy? && reason == 'Target.FailedHealthChecks'
        end

        def internal_error?
          unhealthy? && reason == 'Elb.InternalError'
        end
      end
    end
  end
end
