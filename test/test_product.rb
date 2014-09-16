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
    assert_equal 'Onesize', p.AvailableSizes
  end

  def test_extract_size_from_name_for_bag_product_without_size
    p = bag_product_without_size
    p.send(:extract_size_from_name)
    assert_equal 'Onesize', p.AvailableSizes
  end

  def test_extract_color_from_name
    p = simple_product
    p.send(:extract_color_from_name)
    assert_equal 'Schwarztöne', p.Color
  end

  def test_extract_color_from_name_for_multi_color
    p = multi_color_product
    p.send(:extract_color_from_name)
    assert_equal 'Schwarztöne', p.Color
  end

  def test_extract_color_from_name_for_products_without_color_and_size
    p = variant_product_without_color_and_size
    p.send(:extract_color_from_name)
    assert_equal 'Mehrfarbig', p.Color
  end

  def test_extract_color_from_name_for_bag_product_without_size
    p = bag_product_without_size
    p.send(:extract_color_from_name)
    assert_equal 'Schwarztöne', p.Color
  end

  def test_transform_to_new_format
    p = simple_product
    p.transform_to_new_format
    assert_equal 'Größe: W26 Farbe: Blau', p.ProductDescription
    assert_equal 'True Religion Jeans', p.ProductName
    assert_equal 'W26', p.AvailableSizes
    assert_equal 'Schwarztöne', p.Color
  end

  def test_transform_to_new_format_multi_color
    p = multi_color_product
    p.transform_to_new_format
    assert_equal 'Größe: W26 Farbe: Blau', p.ProductDescription
    assert_equal 'True Religion Jeans', p.ProductName
    assert_equal 'W26', p.AvailableSizes
    assert_equal 'Schwarztöne', p.Color
  end

  def test_transform_to_new_format_for_products_without_color_and_size
    p = variant_product_without_color_and_size
    p.transform_to_new_format
    assert_equal 'Größe: W26 Farbe: Blau', p.ProductDescription
    assert_equal 'True Religion Jeans', p.ProductName
    assert_equal 'Onesize', p.AvailableSizes
    assert_equal 'Mehrfarbig', p.Color
  end

  def test_transform_to_new_format_for_bag_product_without_size
    p = bag_product_without_size
    p.transform_to_new_format
    assert_equal 'Größe: W26 Farbe: Blau', p.ProductDescription
    assert_equal 'Handtasche', p.ProductName
    assert_equal 'Onesize', p.AvailableSizes
    assert_equal 'Schwarztöne', p.Color
  end

end