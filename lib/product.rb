class Product

  @@MULTICOLOR_NAME = 'Mehrfarbig'
  @@COLOR_EXTENSION = 'töne'
  @@ONESIZE_NAME = 'Onesize'

  attr_reader :ProductID,          :ProductCategory,    :Deeplink,
              :ProductName,        :ProductName,        :ImageUrl,
              :ProductDescription, :BrandName,          :Price,
              :PreviousPrice,      :AvailableSizes,     :Tags,
              :EAN,                :LastUpdate,         :UnitPrice,
              :RetailerAttributes, :Color

  def initialize(pid, cat, dl, name, img, descr, brand, price, old_price, sizes, tags, ean, update, unit_price, retailer = nil, color = nil)
    @ProductID = pid
    @ProductCategory = cat
    @Deeplink = dl
    @ProductName = name
    @ImageUrl = img
    @ProductDescription = descr
    @BrandName = brand
    @Price = price
    @PreviousPrice = old_price
    @AvailableSizes = sizes
    @Tags = tags
    @EAN = ean
    @LastUpdate = update
    @UnitPrice = unit_price
    @RetailerAttributes = retailer
    @Color = color
  end

  def transform_to_new_format
    extract_color_from_name
    extract_size_from_name
    trim_product_name
    remove_html_tags_from_description
  end

private

  def extract_color_from_name
    @Color = @ProductName[/(?<=in )(\S*)/]
    if @Color.nil?
      @Color = @@MULTICOLOR_NAME
    else
      @Color = @Color + @@COLOR_EXTENSION
    end
  end

  def extract_size_from_name
    if @AvailableSizes.nil? || @AvailableSizes == ''
      @AvailableSizes = @ProductName.gsub(/^.* in .* Gr. /, '')
      if @AvailableSizes == @ProductName
        @AvailableSizes = @@ONESIZE_NAME
      end
    else
      @AvailableSizes.gsub!(/(^|,?)(\w|ß|ä|ö|ü)*töne,?/, '')
    end
  end

  def trim_product_name
    @ProductName = @ProductName.split(/ in /).first
  end

  def remove_html_tags_from_description
    regex = /<("[^"]*"|'[^']*'|[^'">])*>/
    @ProductDescription.gsub!(regex, '')
  end

end