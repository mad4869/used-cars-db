from read_excel import read_excel
from show_data import show_data
from faker import Faker

# membuat variabel untuk generator Faker dengan lokasi Indonesia
FAKER = Faker('id_ID')

def get_city_table(file_name: str, worksheet_name: str, is_print: bool):
    """
    Fungsi untuk mengambil dummy data tabel city dari file excel
    headers:
        - city_id
        - name
        - location
    args:
        - file_name (str): nama file excel
        - is_print (bool): jika True akan menampilkan hasil data
    return:
        - table (dict): data dalam bentuk tabel
    """

    city_id = []
    name = []
    location = []

    # Menyimpan data hasil pembacaan file excel
    data = read_excel(file_name, worksheet_name)
    
    # Memasukkan data ke dalam masing-masing kolom tabel
    city = {}
    city["city_id"] = [int(data[i]["kota_id"]) for i in range(len(data))]
    city["name"] = [data[i]["nama_kota"] for i in range(len(data))]
    city["location"] = [f'{data[i]["longitude"]}, {data[i]["latitude"]}' for i in range(len(data))]

    # Menampilkan data jika diinginkan
    if is_print:
        show_data(city)
    
    return city

def get_product_table(file_name: str, worksheet_name: str, is_print: bool):
    """
    Fungsi untuk mengambil dummy data tabel product dari file excel
    headers:
        - product_id
        - brand
        - model
        - type
        - year
    arg:
        - file_name (str): nama file excel
        - is_print (bool): jika True akan menampilkan hasil data
    return:
        - table (dict): data dalam bentuk tabel
    """

    product_id = []
    brand = []
    model = []
    body_type = []
    year = []
    
    # menyimpan data hasil pembacaan file excel
    data = read_excel(file_name, worksheet_name)
    
    # memasukkan data ke dalam masing-masing tabel
    product = {}
    product["product_id"] = [int(data[i]['product_id']) for i in range(len(data))]
    product["brand"] = [data[i]['brand'] for i in range(len(data))]
    product["model"] = [data[i]['model'] for i in range(len(data))]
    product["type"] = [data[i]['body_type'] for i in range(len(data))]
    product["year"] = [int(data[i]['year']) for i in range(len(data))]
    # menambahkan kolom color dan distance dengan data dummy
    product["color"] = [FAKER.color_name() for i in range(len(data))]
    product["distance"] = [FAKER.random_int(20_000, 100_000, 5_000) for i in range(len(data))]

    # menampilkan data jika diinginkan
    if is_print:
        show_data(product)
    
    return product