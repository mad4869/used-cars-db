from tabulate import tabulate

def show_data(table: dict):
    """
    Fungsi untuk menampilkan data dalam bentuk tabulasi
    arg:
        - table (dict) : data yang ingin ditampilkan
    return:
        None
    """
    
    tab = tabulate(tabular_data=table,
                    headers=table.keys(),
                    tablefmt="psql",
                    numalign="center")
    print(tab)