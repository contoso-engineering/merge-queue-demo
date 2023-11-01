import { calculate } from '../lib.js'
import * as assert from 'assert'

describe('lib', () => {
  describe('#calculate', () => {
    it('two numbers', () => {
      assert.equal(calculate(1, 1), 2);
    });

    it('error if zero or null number', () => {
      assert.throws(() => { return calculate(1) });
    });
  });
});

