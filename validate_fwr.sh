SetParam() {

        export TIME=`date +%d-%m-%Y_%H.%M.%S`
        export date=`date +%d-%m-%Y`
        export port=22 #default port
        curr_dir="$PWD"


}
Create_Directory_Structure(){
        if [[ ! -d "$curr_dir/connectivity_check" ]]
        then
                echo "directory does not exist,creating";
                mkdir "$curr_dir/connectivity_check";
                mkdir "$curr_dir/connectivity_check/RF_input_dir";
                                mkdir "$curr_dir/connectivity_check/RF_input_archive_dir";
                            mkdir "$curr_dir/connectivity_check/RF_output_dir";
                                mkdir "$curr_dir/connectivity_check/RF_output_archive_dir";
        fi

}
Telnet_Status() {

        SetParam
        curr_dir_temp=$curr_dir
        cd $curr_dir/connectivity_check/RF_input_dir
        fileArr1=(*)
        echo $1
                arg1=$1
				flag=null 
                
                if [ $# -ne 0 ];
                                then

                                        if [ -f "$arg1" ];
                                        then
                                                        
                                                        flag=true
                                                else
                                                        echo "file not present";
                                                        flag=false
                                        fi
                                fi

		
        for file in "${fileArr1[@]}"
        do
                        if [ "$file" != "$arg1" ] && [ $flag == true ];
                                then
                                   

                                       continue ;

                                fi
				if [ $flag == false ];
					then 
						break;
					fi	
                echo "file to cat is $file ";
                        cat $file | while read next
                     do

                             server=`echo $next | cut -d : -f1`
                             port=`echo $next | awk -F":" '{print $2}'`
                             TELNETCOUNT=`sleep 2 | telnet $server $port | grep -v "Connection refused" | grep "Connected to" | grep -v grep | wc -l`

                             if [ $TELNETCOUNT -eq 1 ] ; then
                                     echo -e "$TIME : Connection with $server:$port/ is \E[32m[ OPEN ]\E[0m" >> $file.text.output

                             else

                                     echo -e "$TIME : Connection with $server:$port/ is \E[31m[ NOT OPEN ]\E[0m" >> $file.text.output

                             fi

                     done;
                 mv $file.text.output $curr_dir_temp/connectivity_check/RF_output_dir/$file.text.$TIME
        done;
}
Main() {
        arg1=$1
        Create_Directory_Structure

}
arg1=$1
SetParam
Main $arg1
Telnet_Status $1


