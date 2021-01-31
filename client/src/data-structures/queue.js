'use strict';
import Node from './node.js';

class Queue {
  constructor(node) {
    this.front = node;
    this.rear = null;
  }

  enqueue(item) {
    const newNode = new Node(item);

    if (this.front) {
      this.rear.next = newNode;
      this.rear = newNode;
    } else {
      this.front = newNode;
      this.rear = newNode;
    }
  }

  enqueueRange(array) {
    array.forEach((item) => {
      this.enqueue(item);
    });
  }

  dequeue() {
    const delNode = this.front;
    this.front = this.front.next;
    delNode.next = null;
    return delNode.val;
  }

  peek() {
    return this.front ? this.front.val : null;
  }

  isEmpty() {
    return this.front === null;
  }

  print() {
    while (this.peek()) {
      const val = this.dequeue().val;
      console.log(val);
    }
  }
}

export default Queue;
