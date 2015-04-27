module Services
  def self.registered(app)
    app.get "/services" do
      @services = [1,2,3]
      haml :services
    end
  end
end
