require_relative 'dorus'

interface = Dorus::DorusInterface.new
data      = Dorus::DorusData.new
# Will be changed to #load
data.type      = 0
data.category  = "Цветы"
data.title     = "Продам цветочный магазин"
data.text      = "Отличный магазин честно вам скажу. Вот так вот так вот вооооот!1"
data.images    = [ 'img/img1.jpg', 'img/img2.jpg' ]
data.price     = 420_000
data.name      = "Vasilii V.K."
data.city      = "Анапа"
data.email     = ""
data.phone     = ""
data.url       = "vk.com"
data.skype     = ""

interface.submit(data)
