from get_tables import *
from create_tables import *
from save_to_csv import *

# menyimpan data dummy ke dalam variabel masing-masing tabel
city = get_city_table("../dummy-data/city.xlsx", "city", is_print=True)
product = get_product_table("../dummy-data/car_product.xlsx", "car_product", is_print=True)
seller = create_seller_table(200, is_print=True)
buyer = create_buyer_table(200, is_print=True)
seller_address = create_seller_address_table(200, is_print=True)
buyer_address = create_buyer_address_table(225, is_print=True)
ads = create_ads_table(100, is_print=True)
bids = create_bids_table(20, is_print=True)

list_tables = [city, product, seller, buyer, seller_address, buyer_address, ads, bids]
name_tables = ['city', 'product', 'seller', 'buyer', 'seller_address', 'buyer_address', 'ads', 'bids']

# eksekusi fungsi untuk membuat file csv tiap tabel
for table, name in zip(list_tables, name_tables):
    save_to_csv(table, name)