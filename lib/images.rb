module Images
  def self.registered(app)
    app.get "/images" do
      @content = []
      Dir["data/images/*"].each do |f|
        file_content = File.open(f).read.gsub("/wiki/","https://ru.wikipedia.org/wiki/") if File.file?(f)
        @content << { file: f, content: file_content } if file_content
      end
      haml :images
    end
  end
end
