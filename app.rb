class App < Sinatra::Base
  set public_folder: "public", static: true
  register Sinatra::Partial

  get "/math" do
    @data = eval(File.open("data/math").read)
    @blocks = []

    @data[0..1].each do |d|
      f = File.open("/tmp/ready").read.split("\n")
      next if f.include?(d[:url])
      @command = "curl https://ru.wikipedia.org#{d[:url]}"
      @respond = `#{@command}`
      @content = Nokogiri::HTML(@respond, nil, 'UTF-8')
      @thumbinner = @content.css(".thumbinner").map do |t|
        @blocks << t.inner_html
        File.write("/tmp/ready", d[:url])
      end
    end

    haml :math
  end

  get "/ruby" do
    @result = eval(File.open("data/ruby").read)
    haml :ruby
  end

  def freq(words)
    Hash[words.group_by do |w|
      w
    end.map do |w, ws|
      [w, ws.length]
    end]
  end
end
