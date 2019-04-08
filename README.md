# Synn's Inventory

Synn-inventory is a plugin (also known as a resource) for [FiveM](https://fivem.net) FX servers. 

The inventory offers a user interface for user to interface with, offering an intuitive way to deal with items and management of it. We try offer the users a complete package, along side with an easy API for developer to intergrate their own systems into.

<hr>

## Features
- Inventory system
    - Drag and drop
    - View item details and actions
    - Variable sized inventories
    - Nested inventories
    - Stack system
    - Weight system

- Secure and performant
    - Inventory data lives on the server
    - Keeping performance impact at a minimum.

- User interface
    - Fully responsive 
    - Custom themes
    - Custom layouts

- Powerful developer API
    - Provides interfaces for Lua, C# and javascript.
    - From one single call you can:
        - Open and close inventory
        - Create or destroy inventories.
        - Add, remove or update item types.
        - Add, remove or update items.
        - Bind actions to items
        - Set custom theme(s)
        - etc...

## Could have
- Tetris style inventory
- Item durability or uses.

## Installing

### Prerequisites 
In order to run this resource, you must have the following:
- An up and running FX server with artifacts version 1141 or greater.
- Access to install new resources on your server.
- An (recent, version 3.0.8) installation of [mysql-async](https://github.com/brouznouf/fivem-mysql-async)


### Steps
a) Drag and drop the synn-inventory folder into server/resources.

b) Add `start synn-inventory` to your server config file.

## Building

### Prerequisites 
To build your own version, you need...
- Installation of node
- Installation of npm

### Steps
a) Navigate to the root folder of synn-inventory.

b) Open "src" folder, open a new terminal window here.

c) Run `npm install`

d) Build with `npm run build` or `npm run pbuild` for a production build (miniffied) 

optional: pull `inventory-bundle.js` through a javascript obfuscator, recommended for production builds. We currently don't have an automated option for this.

## Contributing
Please refer the [Contribution Guide](CONTRIBUTING.md) to see how you can contribute.

## License
See [LICENSE.md](LICENSE.md) for the terms and conditions.

## Authors and contributors
- [**Syntasu**](https://gist.github.com/Syntasu) - Initial work