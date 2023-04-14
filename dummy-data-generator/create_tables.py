from faker import Faker
from datetime import datetime
import random

# membuat variabel untuk generator Faker dengan lokasi Indonesia
FAKER = Faker('id_ID')

def create_seller_table(n_seller: int, is_print: bool):
    """
    Fungsi untuk membuat dummy data tabel seller
    headers:
        - seller_id
        - name
        - email
        - phone number
        - created_at
    args:
        - n_seller (int): jumlah seller yang ingin dibuat
        - is_print (bool): jika True akan menampilkan hasil data
    return:
        - table (dict): data dalam bentuk tabel
    """

    # membuat kolom-kolom tabel seller dengan masing-masing data dummy
    seller = {}
    seller["seller_id"] = [i+1 for i in range(n_seller)]
    seller["name"] = [f"{FAKER.first_name()} {FAKER.last_name()}" for i in range(n_seller)]
    seller["email"] = [f"{name.lower().replace(' ', '')}@{FAKER.free_email_domain()}" for name in seller["name"]]
    seller["phone_number"] = [FAKER.phone_number() for i in range(n_seller)]
    seller["created_at"] = [FAKER.date_time_between(start_date=datetime(2020, 1, 1), \
                            end_date=datetime(2023, 4, 16)) for i in range(n_seller)]

    # menampilkan data jika diinginkan
    if is_print:
        show_data(seller)
    
    return seller

def create_buyer_table(n_buyer: int, is_print: bool):
    """
    Fungsi untuk membuat dummy data tabel buyer
    headers:
        - buyer_id
        - name
        - email
        - phone number
        - created_at
    args:
        - n_buyer (int): jumlah buyer yang ingin dibuat
        - is_print (bool): jika True akan menampilkan hasil data
    return:
        - table (dict): data dalam bentuk tabel
    """

    # membuat kolom-kolom tabel buyer dengan masing-masing data dummy
    buyer = {}
    buyer["buyer_id"] = [i+1 for i in range(n_buyer)]
    buyer["name"] = [f"{FAKER.first_name()} {FAKER.last_name()}" for i in range(n_buyer)]
    buyer["email"] = [f"{name.lower().replace(' ', '')}@{FAKER.free_email_domain()}" for name in buyer["name"]]
    buyer["phone_number"] = [FAKER.phone_number() for i in range(n_buyer)]
    buyer["created_at"] = [FAKER.date_time_between(
                            start_date=datetime(2020, 1, 1),
                            end_date=datetime(2023, 4, 16)
                            ) for i in range(n_buyer)]

    # menampilkan data jika diinginkan
    if is_print:
        show_data(buyer)
    
    return buyer

def create_seller_address_table(n_seller_address: int, is_print: bool):
    """
    Fungsi untuk membuat dummy data tabel seller_address
    headers:
        - seller_address_id
        - seller_id
        - city_id
        - address
        - zip_code
    args:
        - n_seller_address (int): jumlah seller address yang ingin dibuat
        - is_print (bool): jika True akan menampilkan hasil data
    return:
        - table (dict): data dalam bentuk tabel
    """

    # membuat kolom-kolom tabel seller_address dengan masing-masing data dummy
    seller_address = {}
    seller_address["seller_address_id"] = [i+1 for i in range(n_seller_address)]
    seller_address["seller_id"] = [random.choice(seller["seller_id"]) for i in range(n_seller_address)]
    seller_address["city_id"] = [random.choice(city["city_id"]) for i in range(n_seller_address)]
    seller_address["address"] = [FAKER.address().split(",")[0] for i in range(n_seller_address)]
    seller_address["zip_code"] = [FAKER.postcode() for i in range(n_seller_address)]

    # menampilkan data jika diinginkan
    if is_print:
        show_data(seller_address)
    
    return seller_address

def create_buyer_address_table(n_buyer_address: int, is_print: bool):
    """
    Fungsi untuk membuat dummy data tabel buyer_address
    headers:
        - buyer_address_id
        - buyer_id
        - city_id
        - address
        - zip_code
    args:
        - n_buyer_address (int): jumlah buyer address yang ingin dibuat
        - is_print (bool): jika True akan menampilkan hasil data
    return:
        - table (dict): data dalam bentuk tabel
    """

    # membuat kolom-kolom tabel buyer_address dengan masing-masing data dummy
    buyer_address = {}
    buyer_address["buyer_address_id"] = [i+1 for i in range(n_buyer_address)]
    buyer_address["buyer_id"] = [random.choice(buyer["buyer_id"]) for i in range(n_buyer_address)]
    buyer_address["city_id"] = [random.choice(city["city_id"]) for i in range(n_buyer_address)]
    buyer_address["address"] = [FAKER.address().split(",")[0] for i in range(n_buyer_address)]
    buyer_address["zip_code"] = [FAKER.postcode() for i in range(n_buyer_address)]

    # menampilkan data jika diinginkan
    if is_print:
        show_data(buyer_address)
    
    return buyer_address

def create_ads_table(n_ads: int, is_print: bool):
    """
    Fungsi untuk membuat dummy data tabel ads
    headers:
        - ad_id
        - title
        - product_id
        - seller_id
        - availability
        - bids_allowed
        - price
        - created_at
    args:
        - n_ads (int): jumlah ads yang ingin dibuat
        - is_print (bool): jika True akan menampilkan hasil data
    return:
        - table (dict): data dalam bentuk tabel
    """

    # membuat kolom-kolom tabel ads dengan masing-masing data dummy
    ads = {}
    ads["ad_id"] = [i+1 for i in range(n_ads)]
    ads["title"] = [FAKER.text() for i in range(n_ads)]
    ads["product_id"] = [random.choice(product["product_id"]) for i in range(n_ads)]
    ads["seller_id"] = [random.choice(seller["seller_id"]) for i in range(n_ads)]
    ads["availability"] = [random.choice([True, False]) for i in range(n_ads)]
    ads["bids_allowed"] = [random.choice([True, False]) for i in range(n_ads)]
    ads["price"] = [FAKER.random_int(100_000_000, 800_000_000, 10_000_000) for i in range(n_ads)]
    ads["created_at"] = [FAKER.date_time_between(start_date=datetime(2020, 1, 1), \
                        end_date=datetime(2023, 4, 16)) for i in range(n_ads)]

    # menampilkan data jika diinginkan
    if is_print:
        show_data(ads)
    
    return ads

def create_bids_table(n_bids: int, is_print: bool):
    """
    Fungsi untuk membuat dummy data tabel bids
    headers:
        - bid_id
        - ad_id
        - buyer_id
        - amount
        - status
        - created_at
    args:
        - n_bids (int): jumlah bids yang ingin dibuat
        - is_print (bool): jika True akan menampilkan hasil data
    return:
        - table (dict): data dalam bentuk tabel
    """

    # membuat kolom-kolom tabel bids dengan masing-masing data dummy
    bids = {}
    bids["bid_id"] = [i+1 for i in range(n_bids)]
    bids["ad_id"] = [random.choice(ads["ad_id"]) for i in range(n_bids)]
    bids["buyer_id"] = [random.choice(buyer["buyer_id"]) for i in range(n_bids)]
    bids["amount"] = [FAKER.random_int(100_000_000, 800_000_000, 10_000_000) for i in range(n_bids)]
    bids["status"] = ["".join(random.choices(["Sent", "Not Sent"], weights=(0.9, 0.1))) for i in range(n_bids)]
    bids["created_at"] = [FAKER.date_time_between(start_date=datetime(2020, 1, 1), \
                            end_date=datetime(2023, 4, 16)) for i in range(n_bids)]

    # menampilkan data jika diinginkan
    if is_print:
        show_data(bids)
    
    return bids