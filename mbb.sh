ruby lib/CsvTransformer.rb 'http://reverse.plenty-test-drive.eu/plenty/api/itemShopbotExport.php?pyk=py_e3d1b204b01c9d58c9d4c3866e6aa08a&eid=7' MyBestBrands_de-out.csv
scp MyBestBrands_de-out.csv rails-deploy@93.92.128.162:~/buddy/shared/documents/product_feed/my_best_brands/
rm MyBestBrands_de-out.csv