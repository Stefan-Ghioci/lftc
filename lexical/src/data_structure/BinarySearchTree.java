package data_structure;

public class BinarySearchTree<T extends Comparable<T>>
{

    private Node<T> root;

    public BinarySearchTree()
    {
        root = null;
    }

    public Node<T> getRoot()
    {
        return root;
    }

    public Node<T> search(T key)
    {
        return searchRec(root, key);
    }

    private Node<T> searchRec(Node<T> node, T key)
    {
        if (node == null || node.getKey().compareTo(key) == 0)
            return node;

        if (node.getKey().compareTo(key) > 0)
            return searchRec(node.getLeft(), key);

        return searchRec(node.getRight(), key);
    }

    public void insert(T key)
    {
        root = insertRec(root, key);
    }

    private Node<T> insertRec(Node<T> root, T key)
    {
        if (root == null)
        {
            root = new Node<T>(key);
            return root;
        }

        if (key.compareTo(root.getKey()) < 0)
            root.setLeft(insertRec(root.getLeft(), key));
        else if (key.compareTo(root.getKey()) > 0)
            root.setRight(insertRec(root.getRight(), key));

        return root;
    }

    public void printInOrder()
    {
        printInOrderRec(root);
    }

    private void printInOrderRec(Node root)
    {
        if (root != null)
        {
            printInOrderRec(root.getLeft());
            System.out.print(root.getKey() + " ");
            printInOrderRec(root.getRight());
        }
    }

}
