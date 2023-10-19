echo "Welcome to BashBook!"

# Create the users folder. This is where we keep our users' data
if ! [ -d "users" ]; then
    mkdir "users"
fi

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