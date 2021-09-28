import csv
def add_to_dictionary(filename_counter, tag):
	with open("dictionary_data/" + str(filename_counter) + ".txt", "w") as dictionary_file:
		if(tag == "ham"):
			dictionary_file.write(str(0))
		elif(tag == "spam"):
			dictionary_file.write(str(1))
	dictionary_file.close()

def create_txt(filename_counter, data):
	with open("test_data/" + str(filename_counter) + ".txt", "w") as txt_file:
		txt_file.write(data)
	txt_file.close()

def main():
	with open('spam.csv', "r", encoding = "ISO-8859-1") as csv_file:
		csv_matrix = csv.reader(csv_file)
		filename_counter = 0
		for row in csv_matrix:
			if (row[0] == "ham" or row[0] == "spam"):
				create_txt(filename_counter, row[1])
				add_to_dictionary(filename_counter, row[0])
				filename_counter = filename_counter + 1
			else:
				print("invalid tag")
	csv_file.close()

if __name__ == "__main__":
	main()
