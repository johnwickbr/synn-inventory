let itemDefinitions = [
    { 
        name: "Credit card", 
        namePlural: "Credit cards",
        codeName: "credit_card",
        maxStackSize: 1,
        description: "A piece of plastic that allows you to pay with thin air, figuratively speaking that is.", 
        image: "ic_credit_card"
    }, 
    {
        name: "Drivers License", 
        namePlural: "Drivers Licenses",
        codeName: "drivers_license",
        maxStackSize: 1,
        description: "A piece of worthless paper, given value by the DMV because you apparently were capable of controlling a car.", 
        image: "ic_drivers_license"
    }, 
    {
        name: "Car key", 
        namePlural: "Car keys",
        codeName: "key",
        maxStackSize: 1,
        description: "A car key, I wonder which car this belongs to... hmmm...", 
        image: "ic_key"
    }, 
    {
        name: "Phone", 
        namePlural: "Phones",
        codeName: "phone",
        maxStackSize: 1,
        description: "A neat device where you can play snake on!", 
        image: "ic_phone"
    }, 
]

let inventoryConfig = {
    name: "some_random_inventory_name",
    element: "left-inventory",
    width: 8,
    height: 8
};

let inventory = new Inventory(inventoryConfig);

inventory.addItemDefinition({
    name: "Penny", 
    namePlural: "Pennies",
    codeName: "penny",
    maxStackSize: 100,
    description: "Wow! that's alot of money!", 
    image: "ic_penny_25"
});

inventory.addItemDefinitions(itemDefinitions);
inventory.addItem("phone", 1, 0, 0);
inventory.addItem("drivers_license", 1, 0, 1);
inventory.addItem("key", 1, 0, 2);
inventory.addItem("penny", 5, 0, 3)
inventory.addItem("penny", 15, 1, 3)
inventory.addItem("penny", 30, 2, 3)
inventory.addItem("penny", 40, 3, 3)
inventory.addItem("penny", 125784371298, 4, 3)
inventory.addItem("penny", 25, 5, 3)
inventory.addItem("penny", 25, 8, 3)
