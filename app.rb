class App < Sinatra::Base
  set public_folder: "public", static: true

  get "/" do
    haml :start
  end
end
