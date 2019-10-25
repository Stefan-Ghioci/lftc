package data_structure;

public class SymbolBinarySearchTree extends BinarySearchTree<Symbol>
{

    public Node<Symbol> searchByAtom(String atom)
    {
        return searchByAtomRec(getRoot(), atom);
    }

    private Node<Symbol> searchByAtomRec(Node<Symbol> node, String atom)
    {
        if(node == null)
            return null;

        if(node.getKey().getAtom().equals(atom))
            return node;

        Node<Symbol> leftResult = searchByAtomRec(node.getLeft(), atom);

        Node<Symbol> rightResult = searchByAtomRec(node.getRight(), atom);

        if(leftResult == null)
            return rightResult;
        if(rightResult == null)
            return leftResult;
        return null;
    }
}
