class App < Sinatra::Base
  set public_folder: "public", static: true
  register Sinatra::Partial

  get "/" do redirect '/math' end

  get "/math" do
    @data = eval File.open("data/math").read
    @ready = read("data/ready")
    @blocks = []

    @data.each_with_index do |d,i|
      next if @ready.include?(d[:url])
      @command = "curl https://ru.wikipedia.org#{d[:url]}"
      @respond = `#{@command}`
      @content = Nokogiri::HTML(@respond, nil, 'UTF-8')
      @thumbinner = @content.css(".thumbinner").map do |t|
        @blocks << t.inner_html
        md5 = Digest::MD5.new
        md5 << t.inner_html
        File.write("data/images/#{md5.hexdigest}", t.inner_html)
      end
      open('data/ready', 'a') { |f| f << "#{d[:url]}\n" }
    end

    haml :math
  end

  get "/compile" do
    @content = []
    Dir["data/images/*"].each do |f|
      @content << File.open(f).read
    end
    haml :compile
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

  def read(file)
    begin
      File.open(file).read.split("\n")
    rescue
      `touch #{file}`
      []
    end
  end
end
