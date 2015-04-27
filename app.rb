class App < Sinatra::Base
  set public_folder: "public", static: true
  register Sinatra::Partial, Math, Images,
    Move, Steps, Ruby, Services
end
