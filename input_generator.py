import csv, os

def create_data(filename_counter, data):
	if not os.path.exists("data_dir"):
		os.makedirs("data_dir")
	with open("data_dir/" + str(filename_counter), "w") as data_file:
		data_file.write(''.join(format(ord(i), '08b') for i in data))
		# data_file.write(data.encode('utf-8'))
	data_file.close()

def create_length(filename_counter, length):
	if not os.path.exists("length_dir"):
		os.makedirs("length_dir")
	with open("length_dir/" + str(filename_counter), "w") as length_file:
		length_file.write(bin(length)[2:])
	length_file.close()

def create_tag(filename_counter, tag):
	if not os.path.exists("tag_dir"):
		os.makedirs("tag_dir")
	with open("tag_dir/" + str(filename_counter), "w") as tag_file:
		if(tag == "ham"):
			tag_file.write(bin(1)[2:])
		elif(tag == "spam"):
			tag_file.write(bin(0)[2:])
	tag_file.close()

def create_path():
	if not os.path.exists("input_path_list"):
		os.makedirs("input_path_list")
	num_files = len(next(os.walk("./data_dir/"))[2])
	f_data = open("./input_path_list/data_path.txt", "w")
	f_length = open("./input_path_list/length_path.txt", "w")
	f_tag = open("./input_path_list/tag_path.txt", "w")
	for i in range (0, num_files):
		f_data.write("data_dir/" + str(i) + "\n")
		f_length.write("length_dir/" + str(i) + "\n")
		f_tag.write("tag_dir/" + str(i) + "\n")
	f_data.close()
	f_length.close()
	f_tag.close()

	# could delete if pythonCS folder is no longer needed in the project
	if not os.path.exists("pythonCS"):
		os.makedirs("pythonCS")

def main():
	NUMOF_TESTS = int(input("Please enter the number of tests you want to run: "))
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
			if (filename_counter >= NUMOF_TESTS):
				break;
	csv_file.close()
	create_path()

if __name__ == "__main__":
	main()
