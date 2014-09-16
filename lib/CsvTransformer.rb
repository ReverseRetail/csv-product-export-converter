require './lib/product'
require 'CSV'

class CsvTransfromer
  @@SEPERATOR = ';'
  @@IN_ENCODING_FROM_TO = 'windows-1250:utf-8'
  @@OUT_ENCODING_FROM_TO = 'utf-8:windows-1250'

  def initialize(input_file_name, output_file_name)
    if input_file_name.nil?
      puts 'FAILED: You have to provide a input filename as first parameter!'
      exit
    end
    if output_file_name.nil?
      output_file_name = input_file_name.gsub('.csv', '-out.csv')
    end

    @products = Array.new
    read_and_transform_products_from_csv input_file_name
    write_output_csv output_file_name
    puts 'FINISHED! Results are written to "' + output_file_name + '"'
  end

  def read_and_transform_products_from_csv input_file_name
    CSV.foreach(input_file_name, headers: true, col_sep: @@SEPERATOR, encoding: @@IN_ENCODING_FROM_TO) do |csv_in|
      product = Product.new( csv_in['ProductID'],     csv_in['ProductCategory'],
                             csv_in['Deeplink'],      csv_in['ProductName'],
                             csv_in['ImageUrl'],      csv_in['ProductDescription'],
                             csv_in['BrandName'],     csv_in['Price'],
                             csv_in['PreviousPrice'], csv_in['AvailableSizes'],
                             csv_in['Tags'],          csv_in['EAN'],
                             csv_in['LastUpdate'],    csv_in['UnitPrice'] )
      product.transform_to_new_format
      @products << product
    end
  end

  def write_output_csv output_file_name
    CSV.open(output_file_name, 'wb', col_sep: @@SEPERATOR, encoding: @@OUT_ENCODING_FROM_TO) do |csv_out|
      csv_out << @products[0].instance_variables.map {|s| s.to_s.gsub('@', '')}
      @products.each do |p|
        csv_out << @products[0].instance_variables.map {|s| @products[0].instance_variable_get(s)}
      end
    end
  end

end

CsvTransfromer.new(ARGV[0], ARGV[1])