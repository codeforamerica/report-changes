class GateKeeper
  def self.demo_environment?
    ENV["DEMO_MODE"] == "true"
  end

  def self.feature_enabled?(feature)
    ENV["#{feature}_ENABLED"] == "true"
  end
end
