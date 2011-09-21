# proto-server

Community-driven Google Protobuf game server.

# Status

* Working on implementing the character creation. Just need to implement request handlers. (writing varints is working, reading varints is not).

# Getting Started

* Download `proto-game` and follow the instructions there.
* Move your `all.descriptor` file containing the raw Google Protobuf descriptor to the directory you will be running the application, eg. `examples/myserver` and then run `coffee myserver.coffee`.

# Notes

* Currently `libprotobuf` appears to dealloc invalid pointers. You must run the server like this: `MALLOC_CHECK_=0 coffee myserver.coffee`

# TODO

* Create redis or mongodb database. Associate game objects directly with database.
* Remove the 'network' prefix and work directly with object bound to network and database.
* Clean up plugins.
* Abstract "payload" from higher-level logic (plugins).

# Examples

Navigate to your `examples/myserver` directory and run your `coffee myserver.coffee` application. Now your server can accept `proto-client` connections.