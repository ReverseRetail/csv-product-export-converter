require 'minitest/autorun'
require './lib/product'

class TestProduct < MiniTest::Unit::TestCase

  #
  # Setup
  #

  def simple_product
    Product.new( '1234',               'CatA > CatB > CatC',
                 'http://example.com', 'True Religion Jeans in Schwarz Gr. W26',
                 'http://example.com', '<p><b>Größe:</b> W26</p> <p><b>Farbe:</b> Blau</p>',
                 'True Religion',      '19,99',
                 '24,99',              '',
                 'tag1, tag2',         'A2-A20777',
                 '09.09.2014',         '' )
  end

  def multi_color_product
    product = simple_product
    product.instance_eval("@ProductName = 'True Religion Jeans in Schwarz & Weiß kariert Gr. W26'")
    product
  end

  def triple_color_product
    product = simple_product
    product.instance_eval("@ProductName = 'LArgentina Bluse in Cremeweiß, Lila & Beige Gr. DE 38 40 42 44'")
    product
  end

  def product_ending_on_in
    product = simple_product
    product.instance_eval("@ProductName = 'Marc Cain Blazer in Dunkelblau Gr. 38 / N3'")
    product
  end

  def variant_product_without_color_and_size
    product = simple_product
    product.instance_eval("@ProductName = 'True Religion Jeans'")
    product
  end

  def bag_product_without_size
    product = simple_product
    product.instance_eval("@ProductName = 'Handtasche in Schwarz'")
    product
  end

  def variant_product_with_prefilled_size
    product = simple_product
    product.instance_eval("@ProductName = 'True Religion Jeans'")
    product.instance_eval("@AvailableSizes = '37,37.5,41.5'")
    product
  end

  def variant_product_with_prefilled_size_and_colors # includes colors
    product = simple_product
    product.instance_eval("@ProductName = 'True Religion Jeans'")
    product.instance_eval("@AvailableSizes = 'Orangetöne,37,37.5,41.5,Blautöne,Brauntöne'")
    product
  end

  def variant_product_with_prefilled_non_numeric_sizes_and_colors
    product = simple_product
    product.instance_eval("@ProductName = 'True Religion Jeans'")
    product.instance_eval("@AvailableSizes = 'Weißtöne,M,L,XL,Grüntöne,Brauntöne'")
    product
  end

  #
  # Tests
  #

  def test_remove_html_tags_from_description
    p = simple_product
    p.send(:remove_html_tags_from_description)
    assert_equal 'Größe: W26 Farbe: Blau', p.ProductDescription
  end

  def test_trim_product_name
    p = simple_product
    p.send(:trim_product_name)
    assert_equal 'True Religion Jeans', p.ProductName
  end

  def test_trim_product_name_for_products_without_color_and_size
    p = variant_product_without_color_and_size
    p.send(:trim_product_name)
    assert_equal 'True Religion Jeans', p.ProductName
  end

  def test_extract_size_from_name
    p = simple_product
    p.send(:extract_size_from_name)
    assert_equal 'W26', p.AvailableSizes
  end

  def test_extract_size_from_name_for_multi_color
    p = multi_color_product
    p.send(:extract_size_from_name)
    assert_equal 'W26', p.AvailableSizes
  end

  def test_extract_size_from_name_for_products_without_color_and_size
    p = variant_product_without_color_and_size
    p.send(:extract_size_from_name)
    assert_equal 'Einheitsgröße', p.AvailableSizes
  end

  def test_extract_size_from_name_for_bag_product_without_size
    p = bag_product_without_size
    p.send(:extract_size_from_name)
    assert_equal 'Einheitsgröße', p.AvailableSizes
  end

  def test_extract_color_from_name
    p = simple_product
    p.send(:extract_color_from_name)
    assert_equal 'Schwarz', p.Color
  end

  def test_extract_color_from_name_for_multi_color
    p = multi_color_product
    p.send(:extract_color_from_name)
    assert_equal 'Schwarz', p.Color
  end

  def test_extract_color_from_name_for_triple_color
    p = triple_color_product
    p.send(:extract_color_from_name)
    assert_equal 'Cremeweiß', p.Color
  end

  def test_extract_color_from_name_for_products_without_color_and_size
    p = variant_product_without_color_and_size
    p.send(:extract_color_from_name)
    assert_equal 'Mehrfarbig', p.Color
  end

  def test_extract_color_from_name_for_bag_product_without_size
    p = bag_product_without_size
    p.send(:extract_color_from_name)
    assert_equal 'Schwarz', p.Color
  end

  def test_extract_color_from_name_for_products_ending_on_in
    p = product_ending_on_in
    p.send(:extract_color_from_name)
    assert_equal 'Dunkelblau', p.Color
  end

  def test_keep_size_for_variant_products_if_exist
    p = variant_product_with_prefilled_size
    p.send(:extract_size_from_name)
    assert_equal '37,37.5,41.5', p.AvailableSizes
  end

  def test_keep_size_for_variant_products_if_exist_and_remove_colors
    p = variant_product_with_prefilled_size_and_colors
    p.send(:extract_size_from_name)
    assert_equal '37,37.5,41.5', p.AvailableSizes
  end

  def test_keep_size_for_variant_products_with_non_numeric_sizes_and_remove_colors
    p = variant_product_with_prefilled_non_numeric_sizes_and_colors
    p.send(:extract_size_from_name)
    assert_equal 'M,L,XL', p.AvailableSizes
  end

  def test_transform_to_new_format
    p = simple_product
    p.transform_to_new_format
    assert_equal 'Größe: W26 Farbe: Blau', p.ProductDescription
    assert_equal 'True Religion Jeans', p.ProductName
    assert_equal 'W26', p.AvailableSizes
    assert_equal 'Schwarz', p.Color
  end

  def test_transform_to_new_format_multi_color
    p = multi_color_product
    p.transform_to_new_format
    assert_equal 'Größe: W26 Farbe: Blau', p.ProductDescription
    assert_equal 'True Religion Jeans', p.ProductName
    assert_equal 'W26', p.AvailableSizes
    assert_equal 'Schwarz', p.Color
  end

  def test_transform_to_new_format_for_products_without_color_and_size
    p = variant_product_without_color_and_size
    p.transform_to_new_format
    assert_equal 'Größe: W26 Farbe: Blau', p.ProductDescription
    assert_equal 'True Religion Jeans', p.ProductName
    assert_equal 'Einheitsgröße', p.AvailableSizes
    assert_equal 'Mehrfarbig', p.Color
  end

  def test_transform_to_new_format_for_bag_product_without_size
    p = bag_product_without_size
    p.transform_to_new_format
    assert_equal 'Größe: W26 Farbe: Blau', p.ProductDescription
    assert_equal 'Handtasche', p.ProductName
    assert_equal 'Einheitsgröße', p.AvailableSizes
    assert_equal 'Schwarz', p.Color
  end

end