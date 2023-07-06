# %%
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
today

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
            "UID=hieudd;\n"
            "PWD=family20101995;")

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
#request
try:
    url = 'https://www.nldc.evn.vn/FullNewsg/100/Thong-tin-thi-truong-dien/default.aspx'
    a = requests.get(url)
    soup= BeautifulSoup(a.text, 'html.parser')
except OSError as error:
    err = error
    log(str(error),log_errorlis)
    print('Web Lỗi: ', error)
    pass

try:
    url = 'https://www.nldc.evn.vn/FullNewsg/100/Thong-tin-thi-truong-dien/default.aspx'
    a = requests.get(url,verify=False)
    soup= BeautifulSoup(a.text, 'html.parser')
    print('Fix lỗi thành công')
    log('Fix Done',log_errorlis)
except OSError as error:
    log(error,log_errorlis)
    print('Web phát sinh lỗi mới: ', error)

#ngay
day = soup.find(id = 'ContentPlaceHolder1_ctl00_lblNgay').text
day = day.replace(' NGÀY ','')
day = str(datetime.strptime(day, '%d/%m/%Y').date())
ID = day.replace('-','')

#công suất lớn nhất
Pmax = soup.find(id = 'ContentPlaceHolder1_ctl00_lblCSMax').text
Pmax = float(Pmax.strip().replace(',','.').replace(' ',''))

#sản lượng ngày
Q = soup.find(id = 'ContentPlaceHolder1_ctl00_lblSLMax').text
Q = float(Q.strip().replace(',','.'))

#sản lượng theo loại hình
table = soup.find('table')
data = []
for row in table.find_all('tr'):
    row_data = []
    for td in row.find_all('td'):
        row_data.append(td.text.strip())
    if row_data:
        data.append(row_data)
data_type = pd.DataFrame(data, columns = ['Type','Slg','Unit'])
data_type['Slg'] = data_type['Slg'].str.replace(',','.').replace('','0').astype(float)

#tổng hợp
datangayX = pd.DataFrame({'ID':[ID],
                          'report_date':[day], 
                          'Pmax':[Pmax], 
                          'Q_total':[Q], 
                          'Thuy_dien': [data_type['Slg'].iloc[0]], 
                          'Than': [data_type['Slg'].iloc[1]],
                          'Khi': [data_type['Slg'].iloc[2]],
                          'Dau': [data_type['Slg'].iloc[3]],
                          'DMT': [data_type['Slg'].iloc[4]],
                          'Gio':[data_type['Slg'].iloc[5]],
                          'Nhap_khau':[data_type['Slg'].iloc[6]],
                          'Khac':[data_type['Slg'].iloc[7]],
                          'last_update':[str(date.today())]})

log('Push start',log_daycheck)
SQLserver_push('Electricity.Daily_output',datangayX)
datangayX.to_csv(folder_csv +'/NamDD_test.csv')
print('DONE')
