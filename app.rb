class App < Sinatra::Base
  set public_folder: "public", static: true
  register Sinatra::Partial

  get "/" do
    haml :start
  end

  get "/environment" do
    haml :environment
  end
end
