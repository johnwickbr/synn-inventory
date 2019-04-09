const MAX_INVENTORY_SIZE = 32 + 1;
class InventoryHelper {

    ToContiguousIndex(width, x, y) {

        if(this.IsInvalidNumber(width, 0, MAX_INVENTORY_SIZE)) {
            console.error(`ToContiguousIndex: variable width is not a valid number.  ${width} > ${MAX_INVENTORY_SIZE} or ${width} < 0`)
            return -1;
        }

        if(this.IsInvalidNumber(x, 0, width)) {
            console.error(`ToContiguousIndex: variable x is not a valid number.  ${x} > ${MAX_INVENTORY_SIZE} or ${x} < 0`)
            return -1;
        }

        if(this.IsInvalidNumber(y, 0, width)) {
            console.error(`ToContiguousIndex: variable y is not a valid number.  ${y} > ${MAX_INVENTORY_SIZE} or ${y} < 0`)
            return -1;
        }

        let index = width * x + y;

        if(this.IsInvalidNumber(index, 0, Math.pow(2, MAX_INVENTORY_SIZE))) {
            console.error("Failed to fetch the contiguous index of (" + x +  ", " + y + ")");
            return -1;
        }

        return index;
    }

    IsInvalidNumber(value, min, max) {
        return value == null || !(Number.isInteger(value) && (value >= min && value < max));
    }

    IsInvalidString(value) {
        return (value == null || value == "");
    }

    IsInvalidObject(value) {
        return value == null || typeof(value) != "object"
    }

    IsObjectEmpty(obj) {
        for(var key in obj) {
            if(obj.hasOwnProperty(key))
                return false;
        }
        return true;
    }

    LogError(message) {
        console.log(`[INVENTORY] [ERROR] ${message}, please report this!`);
    }

    LogWarning(message) {
        console.log(`[INVENTORY] [WARNING] ${message}`);
    }

    Log(message) {
        console.log(`[INVENTORY] ${message}`);
    }
}
class InventoryModel {
    constructor(config, helper, controller) {
        this.config = config;
        this.helper = helper;
        this.view = new InventoryView(config, helper, controller);

        this.items = [];
        this.inventory = [];

        for(let x = 0; x < this.config.width; x++) {
            for(let y = 0; y < this.config.height; y++) {
                let index = this.helper.ToContiguousIndex(this.config.width, x, y);
                this.inventory[index] = {};
            }
        }
    }

    _verifyItem(item) {
        if(this.helper.IsInvalidObject(item)) {
            console.error(`Item definition is invalid, given: ${JSON.stringify(item)}`)
            return { valid: false, data: item };
        }

        if(this.helper.IsInvalidString(item.name)) {
            console.error(`Item defition for 'name' is invalid, given: ${item.name}`);
            return { valid: false, data: item };
        }

        if(this.helper.IsInvalidString(item.namePlural)) {
            item.namePlural = `${item.name}s`;
        }

        if(this.helper.IsInvalidString(item.codeName)) {
            console.error(`Item defition for 'codeName' is invalid, given: ${item.codeName}`);
            return { valid: false, data: item };
        }

        if(this.helper.IsInvalidNumber(item.maxStackSize, 0, Number.MAX_SAFE_INTEGER)) {
            console.error(`Item defition for 'maxStackSize' is invalid, given: ${item.maxStackSize}`);
            return { valid: false, data: item };
        }

        if(this.helper.IsInvalidString(item.image)) {
            console.error(`Item defition for 'image' is invalid, given: ${item.image}`);
            return { valid: false, data: item };
        }
        
        return { valid: true, data: item };
    }

    addItemDefinition(item) {
        let itemValid = this._verifyItem(item);

        if(itemValid.valid) {
            this.items[item.codeName] = item;
        }
    }
    
    hasItem(itemName) {
        return this.items[itemName] != null;
    }
    
    getItem(itemName) {
        if(this.helper.IsInvalidString(itemName)) {
            console.error(`Item name ${itemName} is invalid!`);
            return {found: false, data: {} }
        }

        if(!this.hasItem(itemName)) {
            console.error(`Item name ${itemName} does not exist!`);
            return { found: false, data: {} }
        }

        return { found: true, data: this.items[itemName] }
    }

    addItem(itemName, count, x, y) {
        let item = this.getItem(itemName);

        if(item.found) {
            if(count > item.data.maxStackSize) {
                this.helper.LogWarning(`Added item exceeds max stack size, got: ${count}, expected: 0 < count < ${item.data.maxStackSize}`);
                count = item.data.maxStackSize;
            }

            let index = this.helper.ToContiguousIndex(this.config.width, x, y);

            if(index < 0) {
                return;
            }

            this.inventory[index] = {
                item: item.data,
                count: count
            };

            this.view.setSlot(item.data, count, x, y);
        }
    }

    putItem(itemName, count) {
        let item = this.getItem(itemName);

        if(!item.found) {
            return;
        }

        for(let x = 0; x < this.config.width; x++) {
            for(let y = 0; y < this.config.height; y++) {
                let index = this.helper.ToContiguousIndex(this.config.width, x, y);
                let slot = this.inventory[index];

                if(this.helper.IsObjectEmpty(slot)) {
                    this.inventory[index] = {
                        item: item.data,
                        count: count
                    }

                    return {
                        found: true,
                        x: x,
                        y: y
                    }
                }
            }
        }

        return {
            found: false,
            x: -1,
            y: -1
        }
    }

    moveItem(from, to) {
        //Drag and dropping in the same spot is useless
        if(from.x == to.x && from.y == to.y) {
            return;
        }

        let fromIndex = this.helper.ToContiguousIndex(this.config.width, from.x, from.y);
        let toIndex = this.helper.ToContiguousIndex(this.config.width, to.x, to.y);
        let fromSlot = this.inventory[fromIndex];
        let toSlot = this.inventory[toIndex];

        //Check if we are not dragging an empty slot.
        if(this.helper.IsObjectEmpty(fromSlot)) {
            return;
        }

        this.view.clearViewItem();

        //Our target is empty, let's put it in that.
        if(this.helper.IsObjectEmpty(toSlot)) {
            this.inventory[toIndex] = fromSlot;
            this.inventory[fromIndex] = {};

            this.view.clearSlot(from.x, from.y);
            this.view.setSlot(fromSlot.item, fromSlot.count, to.x, to.y);
            return;
        }

        let fromItem = fromSlot.item;
        let toItem = toSlot.item;

        //Check if of same type, if so, we can possibly stack.
        if(fromItem.codeName == toItem.codeName) {

            //No need to drag if one of the slots is max stack size.
            //Then we want to swap the items.
            if(fromSlot.count == fromItem.maxStackSize ||
               toSlot.count == toItem.maxStackSize) {
                //Items were not of same type, let's switch them then.
                this.inventory[toIndex] = fromSlot;
                this.inventory[fromIndex] = toSlot;
                this.view.setSlot(fromItem, fromSlot.count, to.x, to.y);
                this.view.setSlot(toItem, toSlot.count, from.x, from.y);
                return;
            }

            let nextStackSize = toSlot.count + fromSlot.count;

            //Try putting the stack into to slot if stack limits allow it.
            if(nextStackSize < fromItem.maxStackSize &&
                nextStackSize < toItem.maxStackSize) {

                this.inventory[fromIndex] = {}
                this.inventory[toIndex] = {
                    item: fromItem,
                    count: nextStackSize
                };

                this.view.clearSlot(from.x, from.y);
                this.view.setSlot(fromItem, nextStackSize, to.x, to.y);

                return;
            }

            //We need a fractional stack, let's do so.
            //NOTE: If nextStackSize is more then 2*maxStackSize, then the remainder will
            //      become a destructive operation, removing one stack or more.
            let remainder = nextStackSize % fromItem.maxStackSize;

            this.inventory[fromIndex] = {};
            this.inventory[toIndex] = {
                item: fromItem,
                count: fromItem.maxStackSize
            };
            
            this.view.clearSlot(from.x, from.y);
            this.view.setSlot(fromItem, fromItem.maxStackSize, to.x, to.y);

            if(remainder <= 0) {
                return;
            }

            //Put the remainder somewhere else in the inventory.
            //TODO: we possible want to merge put items.
            let put = this.putItem(toItem.codeName, remainder);

            if(put.found) {
                let putIndex = this.helper.ToContiguousIndex(this.config.width, put.x, put.y);

                this.inventory[putIndex] = {
                    item: toItem,
                    count: remainder
                }

                this.view.setSlot(toItem, remainder, put.x, put.y);
                return;
            }

            //TODO: Drop item, possible report back to the backend
            //      Telling that the inventory is full and return a (list) of rejected items.
            //      But then again, the backend should be inteligent enough to know the inventory is full.
            //      For robustness sake, and so I don't forget, I'm going to keep this in.
        }

        //Items were not of same type, let's switch them then.
        this.inventory[toIndex] = fromSlot;
        this.inventory[fromIndex] = toSlot;
        this.view.setSlot(fromItem, fromSlot.count, to.x, to.y);
        this.view.setSlot(toItem, toSlot.count, from.x, from.y);
    }

    viewItem(x, y) {
        let index = this.helper.ToContiguousIndex(this.config.width, x, y);
        let slot = this.inventory[index];

        if(!this.helper.IsObjectEmpty(slot)) {
            this.view.viewItem(slot.item, slot.count);
        }
        else {
            this.view.clearViewItem();
        }

    }
}

class InventoryView {
    constructor(config, helper, controller) {
        this.config = config;
        this.helper = helper;
        this.controller = controller

        this.element = document.getElementById(this.config.element);

        this.details = {
            header: document.getElementById("item-info-header"),
            image: document.getElementById("item-info-image"),
            description: document.getElementById("item-info-desc")
        }

        if(this.helper.IsInvalidObject(this.element)) {
            this.helper.LogError("Could not find element to bind inventory to")
            return;
        }

        this.slots = [];
        this.createInventory();
    }

    _createSlot(width, margin, x, y, cbDragStart, cbDragEnd, cbClick) {
        let slot = document.createElement("div");
        slot.classList.add("slot");
        slot.classList.add("slot-bg");
        slot.style.width = width + "%" 
        slot.style.paddingBottom = width + "%";
        slot.style.margin = margin + "%";
        slot.style.backgroundImage = "url(assets/theme/slot.png)";
        slot.style.userSelect = "none";

        let slotContent = document.createElement("div");
        slotContent.classList.add("slot-content");
        slotContent.style.userSelect = "none";

        let slotDesc = document.createElement("span");
        slotDesc.classList.add("slot-desc");
        slotDesc.innerHTML = ""
        slotDesc.style.userSelect = "none";

        let slotImage = document.createElement("img");
        slotImage.classList.add("slot-img");
        slotImage.classList.add("hide");
        slotImage.style.userSelect = "none";

        let slotDragDrop = document.createElement("div");
        slotDragDrop.id = `${x}-${y}`
        slotDragDrop.classList.add("slot-drag-drop");
        slotDragDrop.draggable = true;
        slotDragDrop.style.userSelect = "none";

        slotDragDrop.addEventListener("dragstart", (event) => { 
            event.stopPropagation();

            //Set an empty image when dragging
            var img = new Image();
            img.src = 'data:image/gif;base64,R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=';
            event.dataTransfer.setDragImage(img, 0, 0);
            cbDragStart(x, y);
        });

        slotDragDrop.addEventListener("dragover", (event) => { 
            event.preventDefault();
         });
        
        slotDragDrop.addEventListener("drop", (event) => { 
            let tokens = event.target.id.split("-");
            cbDragEnd(parseInt(tokens[0]), parseInt(tokens[1]));
        });

        slotDragDrop.addEventListener("click", (event) => {
            let tokens = event.target.id.split("-");
            cbClick(parseInt(tokens[0]), parseInt(tokens[1]));
        });

        slotContent.appendChild(slotDesc);
        slotContent.appendChild(slotImage);
        slotContent.appendChild(slotDragDrop);
        slot.appendChild(slotContent);

        return {
            slot: slot,
            content: slotContent,
            desc: slotDesc,
            img: slotImage
        };
    }

    createInventory() {
        let itemMargin = 0.15;
        let itemWidth = (100.0 / this.config.width) - (itemMargin * 2.0);
        
        for(let x = 0; x < this.config.width; x++) {
            for(let y = 0; y < this.config.height; y++) {

                //NOTE: These all need to use arrow syntax.
                //      Otherwise to loose reference to "this".
                let dragCallback = (x, y) => { 
                    this.controller.onDragAction(x, y); 
                }

                let dropCallback = (x, y) => { 
                    this.controller.onDropAction(x, y); 
                }

                let clickCallback = (x, y) => {
                    this.controller.onClickAction(x, y);
                }

                let slotElements = this._createSlot(
                    itemWidth, itemMargin, 
                    x, y, 
                    dragCallback,
                    dropCallback,
                    clickCallback
                );
                
                let index = this.helper.ToContiguousIndex(this.config.width, x, y); 
                this.slots[index] = slotElements;

                this.element.appendChild(slotElements.slot);
            }
        }
    }

    setSlot(data, count, x, y) {
        let index = this.helper.ToContiguousIndex(this.config.width, x, y);
        let slot = this.slots[index];

        if(slot.img.classList.contains("hide")) {
            slot.img.classList.remove("hide");
        }

        slot.img.src = `assets/img/${data.image}.png`;
        slot.img.onerror = () => {
            slot.img.src = `assets/img/ic_undefined.png`;
        }

        slot.desc.innerHTML = count + "x";
    }

    clearSlot(x, y) {
        let index = this.helper.ToContiguousIndex(this.config.width, x, y);
        let slot = this.slots[index];

        if(!slot.img.classList.contains("hide")) {
            slot.img.classList.add("hide");
        }

        slot.img.src = `assets/img/ic_undefined.png`;

        slot.img.onerror = () => {
            slot.img.src = "";
        }

        slot.desc.innerHTML = "";
    }

    viewItem(data, count) {
        let name = count > 1 ? 
            data.namePlural : 
            data.name;

        if(count > 1) {
            this.details.header.innerHTML = `${name} (${count}x)`;
        }
        else {
            this.details.header.innerHTML = `${name}`;
        }

        this.details.image.src = `assets/img/${data.image}.png`;
        this.details.description.innerHTML = data.description;
    }

    clearViewItem() {
        this.details.header.innerHTML = "";
        this.details.image.src = "";
        this.details.description.innerHTML = "";
    }
}
class InventoryController {
    constructor(config, helper) { 
        this.config = config;
        this.helper = helper;
        this.model = new InventoryModel(config, helper, this);

        this.self = this;
        this.dragStart = {};
    }

    onAddItemDefinition(item) {
        this.model.addItemDefinition(item);
    }

    onAddItemDefinitions(items) {
        items.forEach(e => {
            this.onAddItemDefinition(e);
        });
    }

    onAddItem(name, count, x, y) {
        this.model.addItem(name, count, x, y);
    }

    onPutItem(name, count) {
        this.model.putItem(name, count);
    }

    onDragAction(dragX, dragY) {
        this.dragStart = { x: dragX, y: dragY };
    }

    onDropAction(dropX, dropY) {
        let dragEnd =  { x: dropX, y: dropY };
        this.model.moveItem(this.dragStart, dragEnd)
    }

    onClickAction(x, y) {
        this.model.viewItem(x, y);
    }
}
class Inventory {
    constructor(config) { 

        this.helper = new InventoryHelper();
        
        if(!this._checkConfig(config)) {
            this.helper.LogError("Woops, config is invalid!");
            return;
        }

        this.controller = new InventoryController(config, this.helper);
    }

    _checkConfig(config) {
        if(this.helper.IsInvalidString(config.name)) {
            this.helper.LogError(`config.name is not a valid string, given: ${config.name}`)
            return false;
        }

        if(this.helper.IsInvalidString(config.element)) {
            this.helper.LogError(`config.element is not a valid string, given: ${config.element}`)
            return false;
        }

        if(this.helper.IsInvalidNumber(config.width, 0, MAX_INVENTORY_SIZE)) {
            this.helper.LogError(`config.width is not a valid interger, given: ${config.width}`)
            return false;
        }

        if(this.helper.IsInvalidNumber(config.height, 0, MAX_INVENTORY_SIZE)) {
            this.helper.LogError(`config.height is not a valid interger, given: ${config.height}`)
            return false;
        }

        return true;
    }

    addItemDefinition(item) {
        this.controller.onAddItemDefinition(item);
    }

    addItemDefinitions(items) {
        this.controller.onAddItemDefinitions(items);
    }

    removeItemDefinition(name) {

    }

    addItem(name, count, x, y) {
        this.controller.onAddItem(name, count, x, y);
    }

    putItem(name, count) {

    }

    removeItem(count, x, y) {

    }

    removeItemByName(name) {

    }
}
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
