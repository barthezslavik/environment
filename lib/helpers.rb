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

def avatar(author)
  return "https://avatars1.githubusercontent.com/u/858547?v=3&s=460" if author == "Slavik"
  return "img/profile-pics/ai.jpg" if author == "Ai"
end
