# FPGA-HDC
FPGA-Based Accelerator For Hyperdimensional Computing (HDC)

## Instructions

 ### Installing pre-requisites
 - The training application runs under Python 3, and requires the following packages: pandas, numpy, scikit-learn and matplotlib. Please have the Python version 3.9 installed. After installing Python, run "install_all_pips.bat" as administrator to install all packages.
 - Install two extensions in VSCode, "Verilog-HDL/SystemVerilog/Bluespec SystemVerilog" by mshr-h and "Verilog HDL" by leafvmaple. The linter setting for the extensions should be "xvlog".
 
 ### Preparing the dataset
 - The SMS ham/spam dataset can be obtained from Kaggle at: https://www.kaggle.com/uciml/sms-spam-collection-dataset
 - Run the "run_python_program.bat" as administrator to transform the dataset in csv file to usable files in Verilog and to record both the Dictionary Memory and the Reference Memory used during the training phase. We will load the dict_mem and ref_mem to our Verilog inference phase later on.

 ### Run the application
 - Use VSCode to open the project folder. Open the "main_tb.v" file and press the green button, "Verilog: Run Verilog HDL Code," on the upper right corner to execute the Verilog file. Users can define the number of tests they are willing to execute in line 17 by changing the value for parameter NUMOF_TESTS, which is by default 10.