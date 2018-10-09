class GateKeeper
  def self.demo_environment?
    if Rails.env.demo?
      true
    else
      ENV["DEMO_MODE"] == "true"
    end
  end
end
