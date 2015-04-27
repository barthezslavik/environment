module Math
  def self.registered(app)
    app.get "/" do redirect '/math' end

    app.get "/math" do
      data = eval File.open("data/math").read
      ready = read("data/ready")
      @blocks = []
      data = data[0..2]

      hydra = Typhoeus::Hydra.new

      requests = data.map do |d|
        request = Typhoeus::Request.new("https://ru.wikipedia.org#{d[:url]}", followlocation: true)
        hydra.queue(request)
        request
      end

      hydra.run

      responses = requests.map do |request|
        content = Nokogiri::HTML(request.response.body, nil, 'UTF-8')
        thumbinner = content.css(".thumbinner").map do |t|
          @blocks << t.inner_html
        end
      end

      haml :math
    end
  end
end
