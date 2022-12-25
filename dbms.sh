#! /bin/bash

function CreateDatabasesDirectory() {

	#[[ -d DBMS ]] || mkdir DBMS
	
	if ! [[ -d Databases ]]; then
		mkdir Databases
	fi
}

CreateDatabasesDirectory



function CreateDoubleLineBreak() {
	echo -e "\n"
	printf "%$(tput cols)s\n" | sed "s/ /*/g"
	echo -e "\n"
	echo "$@"
	echo -e "\n"
	printf "%$(tput cols)s\n" | sed "s/ /*/g"
	echo -e "\n"
}


function CreateSingleLineBreak() {

	echo -e "\n"
	printf "%$(tput cols)s\n" | sed "s/ /*/g"
	echo -e "\n"
}


function RegexMatch() {

	[[ $1 =~ ^[0-9\.\!\@\#\$\%\^\&\*\(\)\?\<\>\=\-\{\}\'\"\/\|\~\,\;\+\:\_]\w* || 
						$1 == *" "* ||
						$1 =~ [[:space:]]+ ||
						$1 == *[\.\!\@\#\$\%\^\&\*\(\)\?\<\>\=\{\}\'\"\/\|\~\,\;\+\:]* ]]

}

function MainMenu() {

	PS3='Enter Your Choice: '	
	select choice in 'Create_Database' 'Select_Database' 'Show_Databases' 'Rename_Database' 'Drop_Database' 'Exit'
		
		do	
	
			if [[ $choice = 'Create_Database' ]]; then
				CreateDatabase
			elif [[ $choice = 'Select_Database' ]]; then
				SelectDatabse
			elif [[ $choice = 'Show_Databases' ]]; then
				ShowDatabases
			elif [[ $choice = 'Rename_Database' ]]; then
				RenameDatabase
			elif [[ $choice = 'Drop_Database' ]]; then
				DropDatabase
			elif [[ $choice = 'Exit' ]]; then
				CreateSingleLineBreak
				exit
			else
				CreateDoubleLineBreak 'Please select a valide choice between available choices above'	
			fi		
		done	
}

function CreateDatabase() {
	
	read -p 'choose a name of your database: ' database_name	
	
	if ! [[ -d Databases/${database_name^^} ]]; then
		if ! RegexMatch $database_name; then
			mkdir Databases/${database_name^^}
			CreateDoubleLineBreak 'Databse has been successfully created'
			MainMenu
		
		else
			CreateDoubleLineBreak 'Name is NOT valid!. Rules:
				1) Not starts with numbers
				2) Not starts with special character
				3) Not contains spaces
				4) Not contain special characters except - or _
			'
			MainMenu
		fi
	else
		CreateDoubleLineBreak 'This name is already taken'
		MainMenu
	fi	
	
}


function SelectDatabse() {


	read -p 'Enter the name of database: ' database_name
	
	if [[ -d Databases/${database_name^^} ]]; then
		cd Databases/${database_name^^}
		 
		CreateSingleLineBreak
		DatabaseDetailsMenu
		#echo "You are now in $database_name database"
	else
		CreateDoubleLineBreak "$database_name database does not exist. We recommend to show database first to ba aware of existing databases"
		MainMenu
	fi
}

function ShowDatabases() {
	 
	if [[ $(ls -A Databases) ]]; then
		content=`ls Databases/`
		CreateDoubleLineBreak $content 
		MainMenu
	else
		CreateDoubleLineBreak 'No Databases Yet!'
		MainMenu
	fi
}


function RenameDatabase() {
	
	read -p 'Enter old name: ' old_name
		
	if [[ -d Databases/${old_name^^} ]]; then
		read -p 'Enter new name: ' new_name
		
		if ! RegexMatch $new_name; then
			mv Databases/${old_name^^} Databases/${new_name^^}
			CreateDoubleLineBreak 'The name has been successfully changed'
			MainMenu
		else
			CreateDoubleLineBreak 'Name is NOT valid!. Please try once again'
			MainMenu
		fi
	else
		CreateDoubleLineBreak "$old_name database does not exist. We recommend to show database first to ba aware of existing databases"
		MainMenu
	fi
}


function DropDatabase() {
	
	read -p 'Enter the name of databse you want to drop: ' database_name	
	
	if [[ -d Databases/${database_name^^} ]]; then
		rm -r Databases/${database_name^^}
		CreateDoubleLineBreak "$database_name has been successfully dropped"
		MainMenu
	else
		CreateDoubleLineBreak "$database_name database does not exist. We recommend to show database first to ba aware of existing databases"
		MainMenu
	fi
}



function DatabaseDetailsMenu() {


	PS3='Please select a choice: '
	select choice in 'Show_Existing_Tables' 'Create_New_Table' 'Drop_Table' 		'Rename_Table' 'Select_Data_From_Table' 'Insert_Data_Into_Table' 'Delete_Data_From_Table' 		'Update_Table' 'Get_Back_To_Main_Menu' 'Exit'
	
	do
	
		if [[ $choice = 'Show_Existing_Tables' ]]; then
			ShowExistingTables
		elif [[ $choice = 'Create_New_Table' ]]; then
			CreateNewTable
		elif [[ $choice = 'Select_Data_From_Table' ]]; then
			CreateSingleLineBreak
			SelectionMenu
		elif [[ $choice = 'Drop_Table' ]]; then
			DropTable
		elif [[ $choice = 'Rename_Table' ]]; then
			RenameTable
		elif [[ $choice = 'Insert_Data_Into_Table' ]]; then
			InsertDataIntoTable
		elif [[ $choice = 'Delete_Data_From_Table' ]]; then
			DeleteDataFromTable
		elif [[ $choice = 'Update_Table' ]]; then
			UpdateTable
		elif [[ $choice = 'Get_Back_To_Main_Menu' ]]; then
			CreateSingleLineBreak
			cd ../..
			MainMenu
		elif [[ $choice = 'Exit' ]]; then
			CreateSingleLineBreak
			exit
		else
			CreateDoubleLineBreak "Please select a valide choice between available choices above"
		fi

	done
}	


function CreateNewTable() {

	read -p 'Enter name of the table: ' table_name
		
	if ! [[ -f $table_name ]]; then
		if ! RegexMatch $table_name; then
			
  		read -p 'Number of columns: ' columns_number
  		
			counter=1
			field_sep="|"
			record_sep="\n"
			primary_key=""
			metadata="Field"$field_sep"Type"$field_sep"key"
			while [ $counter -le $columns_number ]
				do
					read -p "Name of Column No. $counter: " column_name
					echo -e "Type of Column $counter: "
					PS3='Enter type of field: '
					select choice in "int" "str"
					do
						case $choice in
						  int ) column_type="int";break;;
						  str ) column_type="str";break;;
						  * ) echo "Wrong Choice" ;;
						esac
					done
					if [[ $primary_key == "" ]]; then
						echo -e "Make it Primary Key? "
						PS3='Make your choice: '
						select choice in "yes" "no"
						do
						  case $choice in
						    yes ) primary_key="PK";
						    metadata+=$record_sep$column_name$field_sep$column_type$field_sep$primary_key
						    break;;
						    no )
						    metadata+=$record_sep$column_name$field_sep$column_type$field_sep""
						    break;;
						    * ) echo "Wrong Choice" ;;
						  esac
						done
					else
						metadata+=$record_sep$column_name$field_sep$column_type$field_sep""
					fi
					if [[ $counter == $columns_number ]]; then
						temp=$temp$column_name
					else
						temp=$temp$column_name$field_sep
					fi
					((counter++))
				done
			
				touch .$table_name
				echo  -e $metadata  >> .$table_name
				touch $table_name
				echo  -e $temp >> $table_name

				CreateDoubleLineBreak 'The table has been created'
				DatabaseDetailsMenu
	
		else
			CreateDoubleLineBreak 'Name is NOT valid!. Rules:
				1) Not starts with numbers
				2) Not starts with special character
				3) Not contains spaces
				4) Not contain special characters except - or _'
			DatabaseDetailsMenu
		fi
	else
		CreateDoubleLineBreak "This table already exists"
		DatabaseDetailsMenu
	fi	
		
}


function InsertDataIntoTable() {


read -p 'Enter name of the table: ' table_name
  if ! [[ -f $table_name ]]; then
    
		CreateDoubleLineBreak "This table does not exist"
		DatabaseDetailsMenu
		
  fi
	
	columns_number=`awk 'END{print NR}' .$table_name`
	field_sep="|"
	record_sep="\n"
	
	for (( i = 2; i <= $columns_number; i++ ));
		do
			column_name=$(awk 'BEGIN{FS="|"}{ if(NR=='$i') print $1}' .$table_name)
			column_type=$( awk 'BEGIN{FS="|"}{if(NR=='$i') print $2}' .$table_name)
			column_key=$( awk 'BEGIN{FS="|"}{if(NR=='$i') print $3}' .$table_name)
			
			 #echo -e "$column_name ($column_type) = \c"
       #read data
       read -p "$column_name ($column_type) = " data

			# Data Validation
			if [[ $column_type == "int" ]]; then
			  while ! [[ $data =~ ^[0-9]+$ ]];
			  	do
					  echo "invalid datatype!"
					  #echo -e "$column_name ($column_type) = \c"
      			#read data
      			read -p "$column_name ($column_type) = " data
				 done
			fi

			if [[ $column_type == "PK" ]]; then
			  while true 
			  	do
					  if [[ $data =~ ^[`awk 'BEGIN{FS="|" ; ORS=" "}{if(NR != 1)print $(('$i'-1))}' $table_name`]$ ]]; then
					    echo  "NOT a valid input for Primary Key that should be unique and not null!"
					  else
					    break;
					  fi
					  #echo -e "$column_name ($column_type) = \c"
       			#read data
       			read -p "$column_name ($column_type) = " data
			  	done
			fi

			#Set row
			if [[ $i == $columns_number ]]; then
			  row=$row$data$record_sep
			else
			  row=$row$data$field_sep
			fi
		done
		
	echo -e $row"\c" >> $table_name
	if [[ $? == 0 ]]
  then
    CreateDoubleLineBreak "Data Inserted Successfully"
  else
    CreateDoubleLineBreak "Error occured while inserting data into $tableName table"
  fi

	row=""
	DatabaseDetailsMenu	
		
}



function DeleteDataFromTable() {

	read -p 'Enter name of the table: ' table_name
	
	if [[ -f $table_name ]]; then
		read -p 'Enter field name: ' field_name

		field_id=$(awk 'BEGIN{FS="|"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$field_name'") print i}}}' $table_name)
		if [[ $field_id == "" ]]; then
		  CreateDoubleLineBreak "Field NOT found in $table_name table"
		  DatabaseDetailsMenu
		else
		  read -p 'Enter field value: ' field_value
		  result=$(awk 'BEGIN{FS="|"}{if ($'$field_id'=="'$field_value'") print $'$field_id'}' $table_name)
		  if [[ $result == "" ]]; then
		    CreateDoubleLineBreak "Value NOT found"
		    DatabaseDetailsMenu
		  else
		    NR=$(awk 'BEGIN{FS="|"}{if ($'$field_id'=="'$field_value'") print NR}' $table_name)
		    sed -i ''$NR'd' $table_name 
		    CreateDoubleLineBreak "Row has been deleted successfully"
		    DatabaseDetailsMenu
		  fi
		fi
		else
			CreateDoubleLineBreak "This table does not exist"
			DatabaseDetailsMenu
		fi

}



function UpdateTable() {

	read -p 'Enter name of the table: ' table_name
	
	if [[ -f $table_name ]]; then
		read -p 'Enter record number: ' record_number
	
		if [[ $record_number =~ ^[1-9]+$ ]]; then
		
			rows_number=`awk '{print NR}' $table_name | tail -1` 
			
			if [[ $record_number -le $rows_number ]]; then
				read -p 'Enter value you want to change: ' old_value
				
				
				awk "NR==$record_number{print}" $table_name
				
				result=`awk "NR==$record_number{print}" $table_name | grep $old_value`
				
				if [[ $result == '' ]]; then
					CreateDoubleLineBreak 'This value does not exist'
					DatabaseDetailsMenu
				else
					
					read -p 'Enter new value: ' new_value
					sed -i ''$record_number's/'$old_value'/'$new_value'/' $table_name
					
					CreateDoubleLineBreak 'Tabel has been updated'
					DatabaseDetailsMenu
				fi
				
		else
				CreateDoubleLineBreak 'Column number NOT found'
				DatabaseDetailsMenu
			fi
		else
			CreateDoubleLineBreak 'Not valid number'
			DatabaseDetailsMenu
		fi
		
	else
		CreateDoubleLineBreak 'Table does not exist'
		DatabaseDetailsMenu
	fi
		
	

}



function SelectionMenu() {


		PS3='Please select a choice: '
		select choice in 'Select_All_Columns' 'Select_Specific_Column' 'Select_Specific_Record' 'Get_Back_To_DatabaseDetailsMenu' 'Get_Back_To_Main_Menu' 'Exit'
		
			do
				
				if [[ $choice == 'Select_All_Columns' ]]; then
					SelectAllColumns
				elif [[ $choice == 'Select_Specific_Column' ]]; then
					SelectSpecificColumn
				elif [[ $choice == 'Select_Specific_Record' ]]; then
					SelectSpecificRecord
				elif [[ $choice ==  'Get_Back_To_DatabaseDetailsMenu' ]]; then
					CreateSingleLineBreak
					DatabaseDetailsMenu
				elif [[ $choice == 'Get_Back_To_Main_Menu' ]]; then
					cd ../..
					CreateSingleLineBreak
					MainMenu
				elif [[ $choice == 'Exit' ]]; then
					exit
				else
					CreateDoubleLineBreak 'Wrong choice!'
				fi
					
			done	
	

}


function SelectAllColumns() {

	read -p 'Enter table name: ' table_name
	
	if [[ -f $table_name ]]; then
		
	CreateSingleLineBreak
	column -t -s '|' $table_name
	CreateSingleLineBreak
	SelectionMenu
	
	else
		CreateDoubleLineBreak 'This table does not exist!'
		SelectionMenu
	fi

}



function SelectSpecificColumn() {

	
	read -p 'Entet name of the table: ' table_name
	
	if [[ -f $table_name ]]; then
		read -p 'Enter column number: ' column_number
		
		if [[ $column_number =~ ^[1-9]+$ ]]; then
		
			fields_number=`awk -F'|' '{print NF; exit}' $table_name` 
			
			if [[ $column_number -le $fields_number ]]; then
					CreateSingleLineBreak
					awk 'BEGIN{FS="|"}{print $'$column_number'}' $table_name
					CreateSingleLineBreak
					SelectionMenu
			else
				CreateDoubleLineBreak 'Column number NOT found'
				SelectionMenu
			fi
		else
			CreateDoubleLineBreak 'Not valid number'
			SelectionMenu
		fi
		
	else
		CreateDoubleLineBreak 'Table does not exist'
		SelectionMenu
	fi

}


function SelectSpecificRecord() {

	read -p 'Entet name of the table: ' table_name
	
	if [[ -f $table_name ]]; then
		read -p 'Enter record number: ' record_number
		
		if [[ $record_number =~ ^[1-9]+$ ]]; then
		
			rows_number=`awk '{print NR}' $table_name | tail -1` 
			
			if [[ $record_number -le $rows_number ]]; then
					CreateSingleLineBreak
					awk "NR==$record_number{print}" $table_name
					CreateSingleLineBreak
					SelectionMenu
			else
				CreateDoubleLineBreak 'Row number NOT found'
				SelectionMenu
			fi
		else
			CreateDoubleLineBreak 'Not valid number'
			SelectionMenu
		fi
		
	else
		CreateDoubleLineBreak 'Table does not exist'
		SelectionMenu
	fi
}







function ShowExistingTables() {

	if [[ $(ls -A) ]]; then
		content=`ls`
		CreateDoubleLineBreak $content 
		DatabaseDetailsMenu
	else
		CreateDoubleLineBreak 'No Tables Yet!'
		DatabaseDetailsMenu
	fi
	
}



#function ShowTable() {

#	read -p 'Enter name of the table: ' table_name
#	
#	if [[ -f $table_name ]]; then
#		result=`cat -nE $table_name`
#		CreateDoubleLineBreak $result
#		DatabaseDetailsMenu
#	else
#		CreateDoubleLineBreak 'This table does not exists' 
#		DatabaseDetailsMenu
#	fi
#} echo -e "Enter Table Name: \c"
  


function DropTable() {

	read -p 'Enter name of the table: ' table_name
	
	if [[ -f $table_name ]]; then
		rm $table_name
		rm .$table_name
		CreateDoubleLineBreak 'The table has been dropped' 
		DatabaseDetailsMenu
	else
		CreateDoubleLineBreak 'This table does not exists' 
		DatabaseDetailsMenu
	fi
} 


function RenameTable() {

	read -p 'Enter old name: ' old_name
	
	if [[ -f $old_name ]]; then
		read -p 'Enter new name: ' new_name
		if ! RegexMatch $new_name; then
			mv $old_name $new_name
			mv .old_name .$new_name
			CreateDoubleLineBreak "The table has been renamed"
			DatabaseDetailsMenu
		else
			
			CreateDoubleLineBreak 'Name is NOT valid!. Rules:
				1) Not starts with numbers
				2) Not starts with special character
				3) Not contains spaces
				4) Not contain special characters except - or _
			'
			DatabaseDetailsMenu
		fi
	else
		CreateDoubleLineBreak 'This table does not exists'	
		DatabaseDetailsMenu
	fi	
}

MainMenu





