# params: client.sh <id>
# If not id, stop script
# Check if server.sh is running (server.pipe exists)
# make sure that the id is not server
# When this is run, we create a pipe called id.pipe in pipes folder
# Start listening for commands
if [ $# -lt 1 ]; then 
    echo "ERROR: no id provided"
    exit 1
fi

user_id=$1
user_pipe="pipes/$user_id.pipe"
server_pipe="pipes/server.pipe"

# Make sure only one client is used per id at the same time
if [ -f $user_pipe ]; then
    echo "ERROR: Someone is already logged in"
    exit 1
fi

# Check if the user pipe is not server.pipe
if ! [ $user_id == "server" ]; then
    touch $user_pipe
else 
    echo "ERROR: invalid id"
    exit 1
fi

# Check is server is running
if ! [ -f $server_pipe ]; then
    echo "Server is currently under maintenance. Please come back later"
    exit 1
fi


# Create function to delete user's pipe when called
delete_pipe_on_interrupt() {
    echo
    echo "Exiting"
    rm $user_pipe
    exit 0
}

# Listen for ctrl + c and call the delete user pipe function (see above)
trap 'delete_pipe_on_interrupt' SIGINT

while true; do
    read -p "Enter request: " command arg1 arg2 arg3 < /dev/tty

    case $command in
        create)
            echo $user_id $command $arg1 >> $server_pipe
        ;;
        add)
            echo $user_id $command $arg1 $arg2 >> $server_pipe
        ;;
        post)
            echo $user_id $command $arg1 $arg2 $arg3 >> $server_pipe
        ;;
        display)
            echo $user_id $command $arg1 >> $server_pipe
        ;;
        *)
            echo "Accepted commands: |create|add|post|display"
            
    esac

    # Wait for server response
    while true; do
        read response_message

        case $response_message in
        # Response messages for create.sh
            "ok: user created!")
                echo "SUCCESS: user created!"
                break
                ;;
            "nok: user already exists")
                echo "ERROR: User already exists"
                break
                ;;
                
        # Response messages for post_messages.sh
            "ok: message posted")
                echo "SUCCESS: message posted!"
                break
                ;;
            "nok: sender '$arg1' does not exist")
                echo "ERROR: sender '$arg1' does not exist"
                break
                ;;
            "nok: sender '$arg2' does not exit")
                echo "ERROR: sender '$arg2' does not exist"
                break
                ;;
            "nok: user '$arg1' is not a friend of '$arg2'")
                echo "ERROR: user '$arg1' is not a friend of '$arg2'"
                break
                ;;

        # Response messages for add_friend.sh
            "ok: friend added!")
                echo "SUCCESS: friend added!"
                break
                ;;
            "nok: user '$arg1' does not exist")
                echo "ERROR: user '$arg1' does not exist"
                break
                ;;
            "nok: user '$arg2' does not exist")
                echo "ERROR: user '$arg2' does not exist"
                break
                ;;
            "nok: '$arg2' and '$arg1' are already friends")
                echo "ERROR: '$arg2' and '$arg1' are already friends"
                break
                ;;
            
        # Response messages for display_wall.sh
            "nok: no identifier provided")
                echo "Bad Request: No Identifier provided"
                break
                ;;

            "nok: user '$arg1' does not exist")
                echo "ERROR: user '$arg1' does not exist"
                break
                ;;
            "start_of_file")
                # Read header
                # Keep reading until we reach end_of_file
                while true; do
                    read wall_line
                    if [[ $wall_line == "end_of_file" ]] || [[ $wall_line == "" ]]; then
                        break
                    fi
                    echo $wall_line
                done
                break
                ;;
            *)
                sleep 0.2
        esac
    done 
done < $user_pipe