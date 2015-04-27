module Ruby
  def self.registered(app)
    app.get "/ruby" do
      @result = eval(File.open("data/ruby").read)
      haml :ruby
    end
  end
end
