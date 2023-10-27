echo "Welcome to BashBook!"

# Create the users folder. This is where we keep our users' data
if ! [ -d "users" ]; then
    mkdir "users"
fi

# Create pipes folder if it does not exist
if ! [ -d "pipes" ]; then
    mkdir "pipes"
fi

# If server.pipe exists, then there is a server currently running
if [ -f "pipes/server.pipe" ]; then
    echo "Server is already running"
    exit 1
fi

# Create the server pipe
server_pipe="pipes/server.pipe"
touch $server_pipe

# Function to delete the server pipe if interrupted by Ctrl + C
pipe_delete_on_interrupt() {
    echo
    echo "Exiting script via interrupt"
    rm "pipes/server.pipe"
    exit 0
}

# This line listens for ctrl + c and runs the pipe_delete_on_interrupt function
trap 'pipe_delete_on_interrupt' SIGINT

while true; do
    # Read input from server pipe every second
    read user_id command arg1 arg2 arg3
    user_pipe="pipes/$user_id.pipe"

    # Match the command with the appropriate command
    case $command in
        create)
            ./create.sh "$arg1" >> $user_pipe
            ;;
        add)
            ./add_friend.sh "$arg1" "$arg2" >> $user_pipe
            ;;
        post)
            ./post_messages.sh "$arg1" "$arg2" "$arg3" >> $user_pipe
            ;;
        display)
            ./display_wall.sh "$arg1" >> $user_pipe
            ;;
        *)
            # echo "Accepted commands: |create|add|post|display"
            sleep 1
    esac
done < $server_pipe