class AWS < Fog::Bin
  def self.class_for(key)
    Fog::AWS.class_for(key)
  end

  def self.[](service)
    Fog::AWS[service]
  end

  def self.services
    Fog::AWS.services
  end
end
