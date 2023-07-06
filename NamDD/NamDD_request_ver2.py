import re
import time
import json
import pandas as pd
import requests
from bs4 import BeautifulSoup
import numpy as np
pd.options.display.max_columns = 99
from datetime import date
from datetime import datetime
import os
import urllib3
urllib3.disable_warnings()

today = str(date.today())
################################################################################################
parent_dir =  os.getcwd()

folder_log = os.path.join(parent_dir,'log_namdd')
folder_csv = os.path.join(parent_dir,'csv_namdd')

try: 
    os.mkdir(folder_log)
    os.mkdir(folder_csv)
    print('Create Folder: DONE')
except OSError as error: 
    print(error)
    pass

print(parent_dir)
print(folder_log)
print(folder_csv)

#####################################################################################################################
log_daycheck = "daycheck.txt"

log_runcheck = "runcheck.txt"

log_errorlis = "errorlist.txt"

def log(message,logfile):
    timestamp_format = '%Y-%h-%d %H:%M:%S' # Year-Monthname-Day-Hour-Minute-Second
    now = datetime.now() # get current timestamp
    timestamp = now.strftime(timestamp_format)
    with open(os.path.join(folder_log,logfile),"a") as f:
        f.write(timestamp + ',' + message + '\n')

def logerror(message,logfile):
    timestamp_format = '%Y-%h-%d %H:%M:%S' # Year-Monthname-Day-Hour-Minute-Second
    now = datetime.now() # get current timestamp
    timestamp = now.strftime(timestamp_format)
    with open(os.path.join(folder_log,(str(date.today())+'_'+log_errorlis)),"a") as f:
        f.write(timestamp + ',' + message + '\n')
#####################################################################################################################

import subprocess
import sys

def install(package):
    """install package in .py"""
    subprocess.check_call([sys.executable, "-m", "pip", "install", package])

#####################################################################################################################
import time
import pyodbc
from tqdm import tqdm

cnxn_str = ("Driver={SQL Server Native Client 11.0};\n"
            "Server=10.26.2.193;\n"
            "Database=ffa;\n"
            "UID=sa;\n"
            "PWD=123@abc;")

print(cnxn_str)

sqlcnxn = pyodbc.connect(cnxn_str)

sqlcursor = sqlcnxn.cursor()

def SQLserver_push(sql_table_name,python_data):
    """ Dẩy dữ liệu lên SQL theo từng dòng """
    print('PUSH DATA: START')
    start_time = time.time()
    cols = "`,`".join([str(i) for i in python_data.columns.tolist()])
    for i,row in tqdm(python_data.iterrows()):
        try:
            sql = "INSERT INTO " + sql_table_name + " VALUES (" + "?,"*(len(row)-1) + "?)"
            sqlcursor.execute(sql, tuple(row))
            sqlcnxn.commit()
        except:
            log(str(tuple(row)),log_errorlis)
            log('Push error',log_daycheck)
            print(tuple(row))
            pass
    log("PUSH DATA: DONE--- %s seconds ---" % (time.time() - start_time),log_daycheck)
    return print("PUSH DATA: DONE--- %s seconds ---" % (time.time() - start_time))

#####################################################################################################################
url = 'https://www.nldc.evn.vn/ThiTruongDien'
a = requests.get(url)
soup= BeautifulSoup(a.text, 'html.parser')
table = soup.find_all('div', {'class': 'row nameColum'})[1]

#ngay
date = table.find_all('div')[0].get_text().strip().split('Lúc ')[1].split()[0]
date = str(datetime.strptime(date, '%d/%m/%Y').date())

#công suất lớn nhất
Pmax = table.find_all('div')[0].get_text().strip().split('ngày: ')[1].split(' MW')[0]
Pmax = float(Pmax.replace(',','.'))

#sản lượng ngày
Q_total = table.find_all('div')[1].get_text().strip().split('ngày: ')[1].split(' triệu')[0]
Q_total = float(Q_total.split(' [Don')[0].replace(',','.'))

#sản lượng theo loại hình
listQ = []
for i in range(4,28,3):
    listQ.append(round(float(table.find_all('div')[i].get_text().strip().replace(',','.')),1))

#ID
ID = date.replace('-','')

#tổng hợp
datangayX = pd.DataFrame({'ID':[ID],
                          'report_date':[date], 
                          'Pmax':[Pmax], 
                          'Q_total':[Q_total], 
                          'Thuy_dien': [listQ[0]], 
                          'Than': [listQ[1]],
                          'Khi': [listQ[2]],
                          'Dau': [listQ[3]],
                          'DMT': [listQ[5]],
                          'Gio':[listQ[4]],
                          'Nhap_khau':[listQ[6]],
                          'Khac':[listQ[7]],
                          'late_update':[str(today)]
                          })
log('Push start',log_daycheck)
SQLserver_push('Electricity.Daily_output',datangayX)
datangayX.to_csv(folder_csv +'/NamDD_test.csv')
print('DONE')