import pandas as pd
import os
import shutil
# import ast

def preprocess_list(list_str):
    return list_str.replace('\n', '').replace('  ', '')

def preprocess_csv(ptf_i, ptf_o):
    """Read, preprocess, and save the CSV file."""
    data = pd.read_csv(ptf_i)
    data['AMENITIES'] = data['AMENITIES'].apply(preprocess_list)
    data.to_csv(ptf_o, index=False, quoting=1)

if __name__ == "__main__":
    seeds_raw_dir = './seeds_raw'
    seeds_dir = './seeds'
    for file in os.listdir(seeds_raw_dir):
        filename, extension = os.path.splitext(file)
        if extension == '.csv':
            ptf_i = os.path.join(seeds_raw_dir, file)
            ptf_o = os.path.join(seeds_dir, f'seed_{file.lower()}')
            if filename == 'AMENITIES_CHANGELOG':
                preprocess_csv(ptf_i, ptf_o)
            else:
                shutil.copy(ptf_i, ptf_o)
