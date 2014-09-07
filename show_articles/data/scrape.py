import os
import re
import csv
import feedparser
from collections import Counter
from bs4 import BeautifulSoup
from pprint import pprint

def main(argv=None):
	
	# Loading links file
	dir = os.getcwd()
	links_path = dir + '/links.txt'
	# print(links_path)
	links = open(links_path,"U")


	# Loading keywords file
	keywords_path = dir + '/keywords.txt'
	# print(keywords_path)
	keywords_file = open(keywords_path,"r")
	#write output file
	csv_file = open(dir + '/output.csv',"wb")
	a = csv.writer(csv_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_ALL)

	link = links.readlines()
	# print link
	keywords = keywords_file.readlines()
	# print keywords

	#parsed links and tag words will be using
	all_links = []
	all_key = []

	for l in link:
		stripped_l = l.rstrip('\n')
		# print stripped
		all_links.append(stripped_l)
	# print all_links

	for k in keywords:
		stripped_k = k.rstrip('\n')
		# print stripped
		all_key.append(stripped_k)
	# print all_key
	
	#make a set of matching words, ignore case
	findwords = re.compile(r'\b%s\b' % '\\b|\\b'.join(all_key), flags=re.IGNORECASE)
	all_keywords = set(all_key)
	print all_keywords

	parse_url(all_links,all_keywords,findwords,a)
	


def parse_url(all_links,all_keywords,findwords,a):
	#add to the end so I can nicely parse in processing
	endtag = "|>>"
	#stag = "|>>,"

	#header
	data = [['title','url','summary','image','matching-words']]
	#data we want
	temp_data = []
	for al in all_links:
		d = feedparser.parse(al)
		# print len(d.entries)
		# For every article(element) in link
		for e in d.entries:
			# print e
			try:
				e.content
				value = e.content[0].value
			except AttributeError:
				value = e.summary_detail.value

			#for those with different structure
			try:
				e.content
				summ = e.summary
			except AttributeError:
				summ = e.summary_detail.value
			except:
				summ ="none"	
				print "summ is none!"	#noup?


			#get the text to search for keywords
			soup = BeautifulSoup(value)
			full_text = soup.get_text()
			#summary of the text to write in table
			
			if summ:
				so = BeautifulSoup(summ)
				summary = endtag + so.get_text().encode('utf-8') + endtag
				print summary
			else:
				summary = endtag + "none" + endtag
				print "---------- no summary here -------"
		

			# print full_text

			#count matching words in full_text
			cnt0 = Counter()
			cnt = Counter()
			for text in full_text.split(" "):
				# print text
				new_text = text.encode('utf-8')
				new_text = new_text.lower()
				if new_text in all_keywords:
					cnt[new_text] += 1
					cnt0 = cnt
			#convet to string to add endtag		
			match = endtag + str(cnt0)	+ endtag

			# words = is_name_in_text(full_text,all_keywords,findwords)

			# if words:
			# 	if len(words) > 0 :
			# 		count_of_words = Counter(words)
			# 	else: count_of_words = {}
			
			# print words

			# c = count(full_text,all_keywords,findwords)
			# print c

			im = soup.find_all('img')
			# print im
			if len(im) > 0:
				image = endtag + im[0].get('src').encode('utf-8') + endtag
			else: image = endtag + "none"  + endtag
			# for im in soup.find_all('img'):
			#     image = im.get('src')
			#     break
			title =  endtag + e.title.encode('utf-8') + endtag
			url = endtag + e.link.encode('utf-8') + endtag

			temp_data = [title,url,summary,image,match]
			data.append(temp_data)
			# print "------------ New --------------"
			# print "Title -  " + title
			# print "url -  " + url
			# print "image -  " + image
			# print value
			# print "\n\n\n"

			#when finish with article, empty stuff for the next row
			temp_data = []
			#count_of_words = {}
			#count_of_words = count_of_words.clear()
			
	a.writerows(data)

# def is_name_in_text(text, names,findwords):
# 	# print text
# 	ws = []
#         for possible_name in set(findwords.findall(text)):
#         	# print possible_name
#             	if possible_name in names:
#                 	ws.append(possible_name.encode('utf-8'))
#         	return ws

# def count(text, names,findwords):
# 	# print text
#       c = len(findwords.findall(text))
#       return c
        	

if __name__ == "__main__":
    main()