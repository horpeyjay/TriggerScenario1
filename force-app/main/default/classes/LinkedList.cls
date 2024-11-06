public class LinkedList {
    // Custom exception for handling errors
    public class LinkException extends Exception {}

    // Properties of the linked list
    private Node head;
    private Node tail;
    private Integer size;

    // Constructor to initialize the linked list
    public LinkedList() {
        this.head = null;
        this.tail = null;
        this.size = 0;
    }

    // Method to add a new node to the front of the list
    public void addToFront(Integer value) {
        Node newNode = new Node(value);
        if (this.head == null) {
            this.head = newNode;
            this.tail = newNode;
        } else {
            newNode.next = this.head;
            this.head = newNode;
        }
        this.size++;
    }

    // Method to remove a node from the front of the list
    public Integer removeFromFront() {
        if (this.size == 0) {
            throw new LinkException('Empty List');
        }
        Node removedNode = this.head;
        this.head = this.head.next;
        this.size--;
        if (this.size == 0) {
            this.tail = null;
        }
        return removedNode.data;
    }

    // Method to add a new node to the end of the list
    public void addToTail(Integer value) {
        Node newNode = new Node(value);
        if (this.head == null) {
            this.head = newNode;
            this.tail = newNode;
        } else {
            this.tail.next = newNode;
            this.tail = newNode;
        }
        this.size++;
    }

    // Method to remove a node from the end of the list
    public Integer removeFromTail() {
        if (this.size == 0) {
            throw new LinkException('Empty List');
        }
        if (this.size == 1) {
            Node temp = this.head;
            this.head = null;
            this.tail = null;
            this.size--;
            return temp.data;
        }

        Node current = this.head;
        Node newTail = null;

        // Traverse to the second-to-last node
        while (current.next != null) {
            newTail = current;
            current = current.next;
        }

        // Update the tail and disconnect the last node
        this.tail = newTail;
        this.tail.next = null;
        this.size--;
        return current.data;
    }

    // Method to get the current size of the list
    public Integer getSize() {
        return this.size;
    }

    // Inner Node class to represent each element in the linked list
    private class Node {
        public Integer data;
        public Node next;

        // Node constructor to initialize data
        public Node(Integer data) {
            this.data = data;
            this.next = null;
        }
    }
}