## How to test

Make sure you give the scripts the +rwx permissions

1. Run `./server.sh` to start up the server. You can only run one instance of server.sh
2. To run the client, run `./client.sh <name>`, where name will be your BashBook id.

Supported commands:
* add <name> - to add a friend
* display <name> - to display a user's wall
* post <name> <message> - to post a message to a user's wall. You must be friends with them

Note: create <name> is not supported as it is being used by client.sh to create the user if they do not have an account yet

# Developers
Van-Mario Caval
Patriks Briedis
