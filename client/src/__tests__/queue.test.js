'use strict';
import Queue from '../data-structures/queue.js';

console.log = jest.fn();

describe('queue', () => {
  let queue;

  beforeEach(() => {
    queue = new Queue();
  });

  it('Can successfully enqueue into a queue', () => {
    queue.enqueue(1);
    expect(queue.peek()).toEqual(1);
  });

  it('Can successfully enqueue multiple values into a queue', () => {
    queue.enqueue(1);
    queue.enqueue(2);
    expect(queue.front.val).toEqual(1);
    expect(queue.rear.val).toEqual(2);
  });

  it('Can successfully dequeue out of a queue the expected value', () => {
    queue.enqueue(1);
    queue.enqueue(2);

    const dequeueVal = queue.dequeue();
    expect(queue.front.val).toEqual(2);
    expect(queue.front.next).toEqual(null);
    expect(dequeueVal).toEqual(1);
  });

  it('Can successfully peek into a queue, seeing the expected value', () => {
    queue.enqueue(1);
    queue.enqueue(2);
    expect(queue.peek()).toEqual(1);
  });

  it('Can successfully empty a queue after multiple dequeues', () => {
    queue.enqueue(1);
    queue.enqueue(2);
    queue.enqueue(3);
    queue.dequeue();
    queue.dequeue();
    queue.dequeue();
    expect(queue.isEmpty()).toEqual(true);
  });

  it('Can successfully instantiate an empty queue', () => {
    queue = new Queue();
    expect(queue.isEmpty()).toEqual(true);
  });

  it('Can console log all of the values from a queue with print()', () => {
    jest.spyOn(global.console, 'log');
    queue.enqueue(1);
    queue.enqueue(2);
    queue.enqueue(3);
    queue.print();
    expect(console.log).toHaveBeenCalled();
  });
});
