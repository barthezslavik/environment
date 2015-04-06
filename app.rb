class App < Sinatra::Base
  set public_folder: "public", static: true
  register Sinatra::Partial

  get "/" do
    haml :dashboard
  end

  get "/math" do
    #@command = "curl https://ru.wikipedia.org/wiki/%D0%9F%D0%BE%D1%80%D1%82%D0%B0%D0%BB:%D0%9C%D0%B0%D1%82%D0%B5%D0%BC%D0%B0%D1%82%D0%B8%D0%BA%D0%B0"
    #@respond = `#{@command}`
    #@content = Nokogiri::HTML(@respond, nil, 'UTF-8')
    #@links = []
    #@content.css("a").map do |a|
    #  next if ["",nil].include?(a)
    #  @links << { text: a.text, url: a[:href] }
    #end
    #@links = @links[103..293]
    #File.write("data/main", @links)
    
    @data = eval(File.open("data/main").read)
    
    @data.each do |d|
      @command = "curl https://ru.wikipedia.org/wiki/#{d[:url]}"
      @respond = `#{@command}`
      @content = Nokogiri::HTML(@respond, nil, 'UTF-8')
      @thumbinner = @content.css(".thumbinner").map do |t|
        t.css("img").map do |img|
          abort img["href"].inspect
        end
      end
      abort "stop".inspect
    end

    haml :math
  end

  get "/wiki" do
    db = SQLite3::Database.open "data/Default/History2"
    stm = db.prepare "SELECT * FROM urls;"
    @rs = stm.execute 
    haml :wiki
  end

  get "/ruby" do
    
    #@a = `cd ~/ror/allunlock/ && find -type f`.split("\n")
    #File.write("data/files", @a)
   
    #@b = eval(File.open("data/files").read)
    #@c = @b.select{|x| x.include?(".rb") }
    #File.write("data/rb", @c)
    
    @d = eval(File.open("data/rb").read)

    @lines = []
    @d.each_with_index do |file_name, i|
      f = File.open("/home/slavik/ror/allunlock/#{file_name[2..-1]}").read
      g = f.split("\n")
      g.each do |line|
        if line.include?(".")
          next if line.include?("#")
          next if line.split(".").count > 2
          #abort line.inspect if line.include?("text")
          if line.include?("(")
            line = line[/\.(.*?)\(/m, 1]
          else
            line = line[/\.(.*?) /m, 1]
          end
          next if line.include?("{") rescue next
          next if line.include?("'") rescue next
          next if line.include?("]") rescue next
          next if line.include?(",") rescue next
          @lines << line 
        end
      end
    end
    @lines = @lines - [nil, "string", "datetime", "integer", "boolean", "decimal", "text"]
    @result = freq(@lines).sort_by{ |k,v| v }.reverse
    @result = @result.map{|k,v|k.gsub("]","")}
    @result = @result - ["", "X", "0", "SOCKSProxy"]
    @result = @result.sort
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
