import csv
def create_length(filename_counter, length):
	with open("length_data/" + str(filename_counter) + ".txt", "w") as txt_file:
		txt_file.write(length.to_bytes(4, byteorder ='big'))
	txt_file.close()

def create_tag(filename_counter, tag):
	with open("dictionary_data/" + str(filename_counter) + ".txt", "w") as dictionary_file:
		if(tag == "ham"):
			dictionary_file.write(0.to_bytes(4, byteorder ='big'))
		elif(tag == "spam"):
			dictionary_file.write(1.to_bytes(4, byteorder ='big'))
	dictionary_file.close()

def create_data(filename_counter, data):
	with open("test_data/" + str(filename_counter) + ".txt", "w") as txt_file:
		txt_file.write(data)
	txt_file.close()

def main():
	with open('spam.csv', "r", encoding = "ISO-8859-1") as csv_file:
		csv_matrix = csv.reader(csv_file)
		filename_counter = 0
		for row in csv_matrix:
			if (row[0] == "ham" or row[0] == "spam"):
				create_data(filename_counter, row[1])
				create_tag(filename_counter, row[0])
				create_length(filename_counter, len(row[1]))
				filename_counter = filename_counter + 1
			else:
				print("invalid tag")
			if (filename_counter >= 20):
				break;
	csv_file.close()

if __name__ == "__main__":
	main()
