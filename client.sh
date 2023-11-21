# Script must have an id provided
if [ $# -lt 1 ]; then 
    echo "ERROR: no id provided"
    exit 1
fi

# Create variables for user pipe and server pipe
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

# Check if the server is running
if ! [ -f $server_pipe ]; then
    echo "Server is currently under maintenance. Please come back later"
    exit 1
fi

# Check if user exists
if [ -d "users/$user_id" ]; then
    echo "Welcome back, $user_id!"
else
    # Create user if not exists
    echo "Creating your account..."
    echo $user_id create $user_id >> $server_pipe

    # Wait for server response
    while true; do
        read response
        case $response in
        "ok: user created!")
            # Delete the server response and display welcome message
            echo "" > $user_pipe
            echo "Welcome, $user_id"
            break
            ;;
        *)
            # Keep waiting
            sleep 0.1
        esac
    done < $user_pipe
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
    # Read input (specifically) from the terminal
    # This while loop is instructed to read everything from
    # the user pipe (to read server responses), we are forcing this line to read from the terminal
    read -p "Enter request: " command arg1 "arg2" < /dev/tty

    # Execute the command
    # We do not allow the create command here.
    case $command in
        add)
            echo $user_id $command $user_id $arg1 >> $server_pipe
        ;;
        post)
            echo $user_id $command $user_id $arg1 $arg2 >> $server_pipe
        ;;
        display)
            echo $user_id $command $user_id >> $server_pipe
        ;;
        *)
            echo "Accepted commands: |create|add|post|display"
            continue    # GO back to start of loop to listen for command
    esac

    # Wait for server response
    while true; do
        # response_message is from user_id.pipe (a line written by the server)
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
            "nok: user '$arg1' does not exist")
                echo "ERROR: User '$arg1' does not exist"
                break
                ;;
            "nok: user '$arg2' does not exit")
                echo "ERROR: You don't exist"
                break
                ;;
            "nok: cannot post to own wall")
                echo "ERROR: You cannot post to your own wall"
                break
                ;;
            "nok: user '$user_id' is not a friend of '$arg1'")
                echo "ERROR: You are not friends with $arg1"
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
            "nok: '$arg1' and '$user_id' are already friends")
                echo "ERROR: '$arg1' and '$user_id' are already friends"
                break
                ;;
            "nok: Usage: add_friend <user_id> <friend_id>")
                echo "ERROR: no user id or friend id provided"
                break
                ;;
            "nok: self-friending is not permitted")
                echo "ERROR: You cannot add yourself as a friend"
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
            "nok: invalid command")
                echo "Error: Invalid Command"
                break
                ;;
            *)
                # Wait for server to reply.
                sleep 0.2
        esac
    done 
done < $user_pipe