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