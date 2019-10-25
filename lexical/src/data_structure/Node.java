package data_structure;

public class Node<T extends Comparable<T>>
{
    private T key;
    private Node<T> left;
    private Node<T> right;

    Node(T key)
    {
        this.key = key;
        left = null;
        right = null;
    }

    public T getKey()
    {
        return key;
    }

    public void setKey(T key)
    {
        this.key = key;
    }

    public Node<T> getLeft()
    {
        return left;
    }

    public void setLeft(Node<T> left)
    {
        this.left = left;
    }

    public Node<T> getRight()
    {
        return right;
    }

    public void setRight(Node<T> right)
    {
        this.right = right;
    }
}
