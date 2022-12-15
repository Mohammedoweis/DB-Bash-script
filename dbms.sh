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
						$1 =~ [[:space:]] ||
						$1 == *[\.\!\@\#\$\%\^\&\*\(\)\?\<\>\=\{\}\'\"\/\|\~\,\;\+\:]* ]]

}

function MainMenu() {

	PS3='Enter Your Choice: '	
	select choice in 'Create_Database' 'Select_Database' 'Show_Databases' 'Rename_Databse' 	'Drop_Database' 'Exit'
		
		do	
	
			if [[ $choice = 'Create_Database' ]]; then
				CreateDatabase
			elif [[ $choice = 'Select_Database' ]]; then
				SelectDatabse
			elif [[ $choice = 'Show_Databases' ]]; then
				ShowDatabases
			elif [[ $choice = 'Rename_Databse' ]]; then
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
		DatabaseDetails
		#echo "You are now in $database_name database"
	else
		CreateDoubleLineBreak "$database_name database does not exist. We recommend to show 			database first to ba aware of existing databases"
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



function DatabaseDetails() {


	PS3='Please select a choice: '
	select choice in 'Show_Existing_Tables' 'Create_New_Table' 'Show_Table' 'Drop_Table' 		'Rename_Table' 'Select_From_Table' 'Insert_Data_Into_Table' 'Delete_Data_From_Table' 		'Update_Table' 'Get_Back_To_Main_Menu' 'Exit'
	
	do
	
		if [[ $choice = 'Show_Existing_Tables' ]]; then
			ShowExistingTables
		elif [[ $choice = 'Create_New_Table' ]]; then
			CreateNewTable
		elif [[ $choice = 'Show_Table' ]]; then
			ShowTable
		elif [[ $choice = 'Drop_Table' ]]; then
			DropTable
		elif [[ $choice = 'Rename_Table' ]]; then
			RenameTable
		elif [[ $choice = 'Insert_Data_Into_Table' ]]; then
			echo 'Data has been inserted'
		elif [[ $choice = 'Delete_Data_From_Table' ]]; then
			echo 'Data has been deleted'
		elif [[ $choice = 'Update_Table' ]]; then
			echo 'Table has been updated'
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
						
			touch $table_name
			CreateDoubleLineBreak 'The table has been created'
			DatabaseDetails
		
		else
			CreateDoubleLineBreak 'Name is NOT valid!. Rules:
				1) Not starts with numbers
				2) Not starts with special character
				3) Not contains spaces
				4) Not contain special characters except - or _
			'
			DatabaseDetails
		fi
	else
		CreateDoubleLineBreak "This table already exists"
		DatabaseDetails
	fi	
		
}


function ShowExistingTables() {

	if [[ $(ls -A) ]]; then
		content=`ls`
		CreateDoubleLineBreak $content 
		DatabaseDetails
	else
		CreateDoubleLineBreak 'No Tables Yet!'
	fi
	
}



function ShowTable() {

	read -p 'Enter name of the table: ' table_name
	
	if [[ -f $table_name ]]; then
		cat $table_name
			CreateSingleLineBreak
		DatabaseDetails
	else
		CreateDoubleLineBreak 'This table does not exists' 
		DatabaseDetails
	fi
}



function DropTable() {

	read -p 'Enter name of the table: ' table_name
	
	if [[ -f $table_name ]]; then
		rm $table_name
		CreateDoubleLineBreak 'The table has been dropped' 
		DatabaseDetails
	else
		CreateDoubleLineBreak 'This table does not exists' 
		DatabaseDetails
	fi
} 


function RenameTable() {

	read -p 'Enter old name: ' old_name
	
	if [[ -f $old_name ]]; then
		read -p 'Enter new name: ' new_name
		if ! RegexMatch $new_name; then
			mv $old_name $new_name
			CreateDoubleLineBreak "The table has been renamed"
			DatabaseDetails
		else
			
			CreateDoubleLineBreak 'Name is NOT valid!. Rules:
				1) Not starts with numbers
				2) Not starts with special character
				3) Not contains spaces
				4) Not contain special characters except - or _
			'
			DatabaseDetails
		fi
	else
		CreateDoubleLineBreak 'This table does not exists'	
		DatabaseDetails
	fi	
}

MainMenu





