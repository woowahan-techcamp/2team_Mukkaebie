import Dummy from './dummy.js'

const assert = chai.assert;

describe('equal', function () {
    it('should be equal', function () {
        const testDummy = new Dummy();
        const str = "hello..."

        assert.equal(testDummy.printHello(), str);
    });
});