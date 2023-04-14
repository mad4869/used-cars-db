import csv

def save_to_csv(data: dict, nama_file: str):
    """
    Fungsi untuk menyimpan data dummy ke file csv
    args:
        - data (dict): data yang akan dimasukkan ke dalam file csv
        - nama_file (str): nama untuk file csv
    return:
        None
    """
    # membuka file csv
    with open(file=f"{nama_file}.csv", mode="w", newline="") as csv_file:
        # membuat writer csv
        writer = csv.writer(csv_file)

        # write header csv
        writer.writerow(list(data.keys()))

        # mengetahui panjang data
        len_data = len(list(data.items())[0][1])

        # write data ke file csv
        for num in range(len_data):
            row = []
            for key in data.keys():
                row.append(data[key][num])
            writer.writerow(row)