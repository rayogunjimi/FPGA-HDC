import csv
def create_data(filename_counter, data):
	with open("data_dir/" + str(filename_counter), "w") as data_file:
		data_file.write(''.join(format(ord(i), '08b') for i in data))
		# data_file.write(data.encode('utf-8'))
	data_file.close()

def create_length(filename_counter, length):
	with open("length_dir/" + str(filename_counter), "w") as length_file:
		length_file.write(bin(length)[2:])
	length_file.close()

def create_tag(filename_counter, tag):
	with open("tag_dir/" + str(filename_counter), "w") as tag_file:
		if(tag == "ham"):
			tag_file.write(bin(0)[2:])
		elif(tag == "spam"):
			tag_file.write(bin(1)[2:])
	tag_file.close()

def main():
	with open('spam.csv', "r", encoding = "ISO-8859-1") as csv_file:
		csv_matrix = csv.reader(csv_file)
		filename_counter = 0
		for row in csv_matrix:
			if (row[0] == "ham" or row[0] == "spam"):
				create_data(filename_counter, row[1])
				create_length(filename_counter, len(row[1]))
				create_tag(filename_counter, row[0])
				filename_counter = filename_counter + 1
			else:
				print("invalid tag")
			if (filename_counter >= 20):
				break;
	csv_file.close()

if __name__ == "__main__":
	main()
