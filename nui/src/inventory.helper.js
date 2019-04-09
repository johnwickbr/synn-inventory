class InventoryHelper {

    ToContiguousIndex(width, x, y) {

        if(this.IsInvalidNumber(width, 0, MAX_INVENTORY_SIZE)) {
            console.error(`ToContiguousIndex: variable width is not a valid number.  ${width} > ${MAX_INVENTORY_SIZE} or ${width} < 0`)
            return -1;
        }

        if(this.IsInvalidNumber(x, 0, width)) {
            console.error(`ToContiguousIndex: variable x is not a valid number.  ${x} >= ${width} or ${x} < 0`)
            return -1;
        }

        if(this.IsInvalidNumber(y, 0, width)) {
            console.error(`ToContiguousIndex: variable y is not a valid number.  ${y} >= ${width} or ${y} < 0`)
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