# scrape dependencies
import requests
import re
from bs4 import BeautifulSoup as bs

# data analysis dependencies
import pandas as pd
import numpy as np
import csv

import datetime as dt
import time

# set the url to scrape
url = 'https://www.ncbi.nlm.nih.gov/pubmed/?term=parkinsons+disease'

# set up beautiful soup to scrape
response = requests.get(url)
soup = bs(response.text, 'html.parser')

# lets scrape the article titles
journals = soup.find_all("p", attrs={'class':'title'})

# searching for the journal titles
journals_len = len(journals)
print(f"There are {journals_len} journals to scrape on the first page.")

# loop through journals to print titles
for i in range(0,20):
    journals[i].text.strip()

# set the main url that we will concatanate with the pubmed id
main_url = 'https://www.ncbi.nlm.nih.gov/pubmed/'
print(main_url)

# set empty links_all list to append to 
links_all = []

# set pubmed ids list to append to
pubmed_ids = []

# set empty list to append scrape_links to
scrape_links = []

# function to get links
def get_links(main_url):
    
    # use bs to scarpe p tags with class - title
    links = soup.find_all("p",attrs={'class':'title'})
      
    # testing to see how my links / journals to scrape
    articles_to_scrape = len(links)
    print(f"There are {articles_to_scrape} articles to scrape.")
    print("----------------------------------------------")
    
    # loop through links to convert to string
    for i in range (len(links)):
        links_all.append(str(links[i]))
        print(links[i])
        print("----------------------------------------------")
        
    # slice through links_all to test
    len(links_all)
    links_all[1]
    
    # loop through links all and use regex to grab the id numbers
    for i in range (len(links_all)):
        pubmed_ids.append(re.findall(r'\d{8}',links_all[i]))
    
    # print out info for pubmed_ids
    len(pubmed_ids)
    type(pubmed_ids)
    print(pubmed_ids)
    print("----------------------------------------------")
    
    # use itertools to transform pubmed ids from an array withn an array into one list
    import itertools
    pubmed_merged = list(itertools.chain.from_iterable(pubmed_ids))
    
    # slice through pubmed_merged to see what itertools did
    pubmed_merged[0]
    
    # concat main_url with a slice of pubmed_merged before we loop
    print(main_url + str(pubmed_merged[0]))
    
    # append merged links to links_all
    for i in range (len(pubmed_merged)):
        scrape_links.append(main_url + str(pubmed_merged[i]))

# RUN FUNCTION
get_links(main_url)

# delete duplicates in scrape_links and assign to new variable scrape_links_final
scrape_links_final = list(set(scrape_links))
len(scrape_links_final)

# testing scrape_links
for i in scrape_links_final:
    print(i)

# slice out scrape_links_final so we can scrape 5 articles at a time
links_1 = scrape_links_final[0:5]
print(links_1)

links_2 = scrape_links_final[5:10]
print(links_2)

links_3 = scrape_links_final[10:15]
print(links_3)

links_4 = scrape_links_final[15:20]
print(inks_4)

# SELENIUM - Web browser automation
from splinter import Browser
from selenium import webdriver

# make sure chrome browser exe is in current directory
# chrome browser exe is not necessary for MACS
executable_path = {'executable_path': 'chromedriver'}

# create dict to append data to
article_dict = {"title": [],
               "abstract": []}

# create get article info function
abstract = []

def get_article_info(links_1):
    
    # iterate through articles
    for i in links_1:
        
        # sets up scraper
        browser = Browser('chrome', headless=False)
        html = browser.html
        response2 = requests.get(i)
        soup2 = bs(response2.text, 'html.parser')
    
        browser.visit(i)
    
        # there are two 'h1' tags on this page. slice out index 0
        title_one = soup2.find_all('h1')
        article_one_title = title_one[1].text.strip()
    
        # slice h1 at index 1 to grab article title
        title.append(article_one_title)
    
        # get abstract
        abstract.append(soup2.find("div", attrs={'class': 'rprt_all'}).text.strip()) 

### RUN ARTICLE INFO FUNCTION ###

get_article_info(links_1)
#get_article_info(links_2)
#get_article_info(links_3)
#get_article_info(links_4)

for i in title:
    print(i + "\n")

len(title)

for i in abstract:
    print(i)
    print("\n")

len(abstract)

# Add title and abstract to article_dict
article_dict["title"].append(title)
article_dict["abstract"].append(abstract)
print(article_dict)

# Save article_dict to json
import json
json = json.dumps(article_dict)
f = open("data/parkinsons_2.json","w")
f.write(json)
f.close()