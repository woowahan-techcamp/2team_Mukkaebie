import Bottle from './bottle.js'

class Dummy {
    constructor() {
        this.hello = "hello...";
        this.bottle = new Bottle();
    }

    printHello() {
        console.log(this.hello);
        return this.hello
    }
}

export default Dummy;