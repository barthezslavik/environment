module Code
  def self.registered(app)
    app.get "/code" do
      #code = File.open("data/research.rb").read
      #parser    = RubyParser.new
      #ruby2ruby = Ruby2Ruby.new
      #@sexp      = parser.process(code)
      #ap @sexp
      haml :code
    end
  end
end
