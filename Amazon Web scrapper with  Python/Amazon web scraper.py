#Importing libs
from bs4 import BeautifulSoup
import requests
import smtplib
import time
import datetime

#connect to website
URL='https://www.amazon.eg/-/en/Apple-iPhone-Pro-Max-256/dp/B0BDJBNN7N/ref=sr_1_1?pf_rd_i=21832883031&pf_rd_m=A1ZVRGNO5AYLOV&pf_rd_p=8c5325c8-2d1e-43fb-8ff0-39ab3ae7ffd4&pf_rd_r=SMBMWRNZWYA33E1BETTG&pf_rd_s=merchandised-search-14&pf_rd_t=101&qid=1680922890&refinements=p_89%3AApple&s=electronics&sr=1-1'

headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36 Edg/112.0.1722.34"}

page= requests.get(URL,headers=headers)

soup1 = BeautifulSoup(page.content, "html.parser")

soup2 = BeautifulSoup(soup1.prettify(), "html.parser")

title = soup2.find(id="productTitle").get_text()
details = soup2.find(id="1").get_text()
title = title.strip()
details=details.strip()

print(title)
type(details)
#date of data
import datetime
today=datetime.date.today()
print(today)


# creating CSV file
import csv

header = ['Title','Details','Date']

data = [title,details,today]


with open('Amazonscraper.csv','w',newline='',encoding='UTF8')as f:
    writer = csv.writer(f)
    writer.writerow(header)
    writer.writerow(data)


#
import pandas as pd

df=pd.read_csv(r'C:\Users\Mohamed\Amazonscraper.csv')
print(df)

###
with open('Amazonscraper.csv','a+',newline='',encoding='UTF8')as f:
    writer = csv.writer(f)
    writer.writerow(data)

def check_details_update():
    URL='https://www.amazon.eg/-/en/Apple-iPhone-Pro-Max-256/dp/B0BDJBNN7N/ref=sr_1_1?pf_rd_i=21832883031&pf_rd_m=A1ZVRGNO5AYLOV&pf_rd_p=8c5325c8-2d1e-43fb-8ff0-39ab3ae7ffd4&pf_rd_r=SMBMWRNZWYA33E1BETTG&pf_rd_s=merchandised-search-14&pf_rd_t=101&qid=1680922890&refinements=p_89%3AApple&s=electronics&sr=1-1'

    headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36 Edg/112.0.1722.34"}

    page= requests.get(URL,headers=headers)

    soup1 = BeautifulSoup(page.content, "html.parser")

    soup2 = BeautifulSoup(soup1.prettify(), "html.parser")

    title = soup2.find(id="productTitle").get_text()
    details = soup2.find(id="1").get_text()
    title = title.strip()
    details=details.strip()
    
    import datetime
    today=datetime.date.today()
    
    import csv

    header = ['Title','Details','Date']

    data = [title,details,today]
    with open('Amazonscraper.csv','a+',newline='',encoding='UTF8')as f:
        writer = csv.writer(f)
        writer.writerow(data)
    
while(True):
    check_details_update()
    time.sleep(86400)


import pandas as pd

df=pd.read_csv(r'C:\Users\Mohamed\Amazonscraper.csv')
print(df)