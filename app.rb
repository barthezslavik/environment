class App < Sinatra::Base
  set public_folder: "public", static: true
  register Sinatra::Partial

  get "/" do
    haml :dashboard
  end

  get "/wiki" do
    db = SQLite3::Database.open "data/Default/History2"
    #stm = db.prepare "SELECT * FROM sqlite_master WHERE type='table';"
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
