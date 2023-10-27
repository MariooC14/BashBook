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
touch "pipes/server.pipe"

# Function to delete the server pipe if interrupted by Ctrl + C
pipe_delete_on_interrupt() {
    echo
    echo "Exiting script via interrupt"
    rm "pipes/server.pipe"
    exit 2
}

# This line listens for ctrl + c and runs the pipe_delete_on_interrupt function
trap 'pipe_delete_on_interrupt' SIGINT

while true; do
    # Read input and split each word into variables
    read -p "Enter request: " command arg1 arg2 arg3

    # Match the command with the appropriate command
    case $command in
        create)
            ./create.sh "$arg1"
            ;;
        add)
            ./add_friend.sh "$arg1" "$arg2"
            ;;
        post)
            ./post_messages.sh "$arg1" "$arg2" "$arg3"
            ;;
        display)
            ./display_wall.sh "$arg1"
            ;;
        *)
            echo "Accepted commands: |create|add|post|display"
    esac
done