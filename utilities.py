def genereate_filename_list(string1, string2 = "", string3 = ""):
	with open("utility_output.txt", "w") as output_file:
		for counter in range(0,5571):
			if(string2 == ""):
				output_file.write(string1 + str(counter) + "\n")
			elif(string3 == ""):
				output_file.write(string1 + str(counter) + string2 + "\n")
			else:
				output_file.write(string1 + str(counter) + string2 + str(counter) + string3 + "\n")
			

def main():
	genereate_filename_list("test_path_list[", "] = test_data/", ".txt;")
	#genereate_filename_list("dictionary_path_list[", "] = disctionary_data/", "1.txt;")

if __name__ == "__main__":
	main()
