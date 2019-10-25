package data_structure;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class BinarySearchTreeTest
{

    private BinarySearchTree<Integer> binarySearchTree;

    @BeforeEach
    void setUp()
    {
        binarySearchTree = new BinarySearchTree<>();
    }


    @Test
    void getRoot()
    {
        assertNull(binarySearchTree.getRoot());

        binarySearchTree.insert(1);
        binarySearchTree.insert(2);
        binarySearchTree.insert(3);
        binarySearchTree.insert(4);

        assertEquals(binarySearchTree.getRoot().getKey(), 1);
    }

    @Test
    void search()
    {

        assertNull(binarySearchTree.search(3));

        binarySearchTree.insert(1);
        binarySearchTree.insert(2);
        binarySearchTree.insert(3);
        binarySearchTree.insert(4);

        assertNull(binarySearchTree.search(7));

        assertNotNull(binarySearchTree.search(3));
    }

    @Test
    void insert()
    {
        assertNull(binarySearchTree.search(7));

        binarySearchTree.insert(7);

        assertNotNull(binarySearchTree.search(7));
    }
}