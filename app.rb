class App < Sinatra::Base
  set public_folder: "public", static: true
  register Sinatra::Partial

  get "/" do
    haml :dashboard
  end

  get "/environment" do
    haml :environment
  end
end
