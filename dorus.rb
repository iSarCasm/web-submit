require 'mechanize'

module Dorus
  class DorusInterface
    FORM_LINK   = 'http://www.dorus.ru/add.html'
    ACTION_LINK = 'http://www.dorus.ru/action.php'
    DEBUG       =  true

    def initialize
      @mechanize = Mechanize.new
      @page = @mechanize.get('http://www.dorus.ru/add.html')
      @fake_form = Mechanize::Form.new(@page.at(".addtable"))
    end

    def submit(dorus_data)
      submit_post(dorus_data)
      attach_images(dorus_data)
    end

    def submit_post(data)
      data = post_data(data)
      header = post_header(data)
      request = @mechanize.post(ACTION_LINK, data, header)
      @id = request.body.split[1]
      if DEBUG
        puts request.response
        puts request.body
        puts @mechanize.current_page.title
      end
    end

    def post_header(data)
      data_length = data.map { |k, v| v.to_s.length }.inject(&:+)
      { 'Accept-Charset'  => 'windows-1251',
        'Accept-Language' => 'ru, en',
        'Content-Length'  => data.length,
        'Contant-type'    => 'application/x-www-form-urlencoded' }
    end

    def post_data(data)
      { 'act' => 'newpost',
        'type' => data.type,
        'category' => find_option(@fake_form, 'category', data.category),
        'title' => data.title,
        'text' => data.text,
        'price' => data.price,
        'name' => data.name,
        'city' => find_option(@fake_form, 'city', data.city),
        'email' => data.email,
        'phone' => data.phone,
        'url' => data.url,
        'skype' => data.skype,
        'expire' => 91,
        'coords' => '' }
    end

    def attach_images(data)
      data.images.each.with_index do |img, i|
        image_request = @mechanize.post(ACTION_LINK, image_data(img, i))
        if DEBUG
          puts image_request.response
          puts image_request.body
        end
      end
    end

    def image_data(img, i)
      { 'act' =>  'uploadphoto',
        'MAX_FILE_SIZE' => '12582912',
        'id' => @id,
        'photonum' => (i+1),
        "photo#{i+1}" => File.new(img) }
    end

    private
      def find_option(form, field_id, text)
        value = nil
        form.field_with(:id => field_id).options.each{|o| value = o if o.text == text }
        raise ArgumentError, "No option with text '#{text}' in field '#{field_id}'" unless value
        value
      end

      def select_option(form, field_id, text)
        form.field_with(:id => field_id).value = find_option(form, field_id, text)
      end
  end

  class DorusData
    attr_accessor(:type, :category, :title,
                  :text, :images, :price,
                  :name, :city, :email,
                  :phone, :url, :skype,
                  :coords, :expire)

    def initialize; end

    def load(source)
      # External format
    end
  end
end
