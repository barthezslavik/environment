module Move
  def self.registered(app)
    app.get "/move" do
      new_path = params[:file].split("/").insert(2, "moved").join("/")
      `mv #{params[:file]} #{new_path}`
      redirect "/compile"
    end
  end
end
