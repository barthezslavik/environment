module Steps
  def self.registered(app)
    app.get "/steps" do
      @steps = [
        { author: "Slavik", content: "Макет" },
        { author: "Ai", content: "Категории разделов" },
        { author: "Slavik", content: "Сетка" },
        { author: "Ai", content: "Изображения по категориям" },
        { author: "Slavik", content: "Гитхаб" },
        { author: "Slavik", content: "Шаги" },
      ]
      haml :steps
    end
  end
end
