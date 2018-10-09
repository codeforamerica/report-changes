class GateKeeper
  def self.demo_environment?
    ENV["DEMO_MODE"] == "true"
  end
end
