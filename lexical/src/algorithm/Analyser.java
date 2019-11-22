package algorithm;

import data_structure.*;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Analyser
{
    private FileInputStream reader;

    private List<String> keywords;
    private List<String> operators;
    private List<String> separators;
    private List<PifElement> programInternalForm;

    private SymbolBinarySearchTree symbols;

    private FiniteAutomata constantAutomata;
    private FiniteAutomata identifierAutomata;
    private FiniteAutomata alphanumericAutomata;

    public BinarySearchTree<Symbol> getSymbols()
    {
        return symbols;
    }

    public List<PifElement> getProgramInternalForm()
    {
        return programInternalForm;
    }

    public Analyser(File file)
    {
        this.programInternalForm = new ArrayList<>();
        this.symbols = new SymbolBinarySearchTree();
        loadSpecification();
        loadFile(file);
        loadAutomatons();
    }

    private void loadAutomatons()
    {
        try
        {
            constantAutomata = new FiniteAutomata("resources/automata/constant");

            List<List<List<String>>> transitions = constantAutomata.getTransitions();
            transitions.get(6).get(6).addAll(Arrays.asList(" ", ","));
            constantAutomata.setTransitions(transitions);

            identifierAutomata = new FiniteAutomata("resources/automata/identifier");
            alphanumericAutomata = new FiniteAutomata("resources/automata/alphanumeric");
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
    }

    private void loadFile(File file)
    {
        try
        {
            this.reader = new FileInputStream(file);
        }
        catch (FileNotFoundException e)
        {
            e.printStackTrace();
        }
    }

    private void loadSpecification()
    {
        try
        {
            operators = Files.readAllLines(Paths.get("resources\\specification\\operators.txt"));
            separators = Files.readAllLines(Paths.get("resources\\specification\\separators.txt"));
            keywords = Files.readAllLines(Paths.get("resources\\specification\\keywords.txt"));
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
    }

    public void analyse() throws Exception
    {
        String atom = "";
        String character;
        int position = 0;
        int lines = 1;

        int quotationsOpen = 0;
        int quotationOpenPosition = 0;
        int quotationOpenLine = 0;

        while (reader.available() > 0)
        {

            character = String.valueOf((char) reader.read());
            position++;

            if (character.equals("\r"))
                continue;
            if (character.equals("\n"))
            {
                lines++;
                position = 0;
                continue;
            }


            if (character.equals("\""))
            {
                quotationsOpen++;
                if (quotationsOpen == 1)
                {
                    quotationOpenLine = lines;
                    quotationOpenPosition = position;
                }
                if (quotationsOpen == 2)
                {
                    atom += character;
                    classify(atom, position - atom.length() + 1, lines);
                    atom = "";
                    quotationsOpen = 0;
                    continue;
                }
            }

            if (quotationsOpen == 1)
            {
                atom += character;
                continue;
            }

            if (alphanumericAutomata.verifySequence(character))
            {
                if (alphanumericAutomata.verifySequence(atom) || atom.isEmpty())
                    atom += character;
                else if (operators.contains(atom))
                {
                    classify(atom, position - atom.length() + 1, lines);
                    atom = character;
                }
                else
                    throw new Exception("Character \"" + character + "\" isn't recognized by the analyser. " +
                                                getLocationFormattedString(position, lines));
            }
            else if (operators.contains(character))
            {
                if (alphanumericAutomata.verifySequence(atom))
                {
                    classify(atom, position - atom.length() + 1, lines);
                    atom = character;
                }
                else if (operators.contains(atom) || atom.isEmpty())
                {
                    atom += character;
                    if (!operators.contains(atom))
                        throw new Exception("Operator \"" + character + "\" is misplaced. " +
                                                    getLocationFormattedString(position, lines));
                }
            }
            else if (separators.contains(character))
            {
                if (!atom.isEmpty())
                {
                    classify(atom, position - atom.length() + 1, lines);
                    atom = "";
                }
                classify(character, position, lines);
            }
            else
                throw new Exception("Character \"" + character + "\" isn't recognized by the analyser. " +
                                            getLocationFormattedString(position, lines));
        }

        if (quotationsOpen == 1)
            throw new Exception(" Quotation mark opened, but never closed. " +
                                        getLocationFormattedString(quotationOpenPosition, quotationOpenLine));
    }

    private String getLocationFormattedString(int position, int lines)
    {
        return "(line " + lines + ", position " + position + ") ";
    }

    private void classify(String atom, int position, int lines) throws Exception
    {
        Integer identifierCode = 1;
        Integer constantCode = 2;
        int nonSymbolCodeBase = 3;

        if (keywords.contains(atom))
        {
            Type type = Type.___KEYWORD;
            Integer code = nonSymbolCodeBase + keywords.indexOf(atom);
            Integer index = -1;
            PifElement element = new PifElement(code, index, type, atom);
            programInternalForm.add(element);
        }
        else if (operators.contains(atom))
        {
            Type type = Type.__OPERATOR;
            Integer code = nonSymbolCodeBase + keywords.size() + operators.indexOf(atom);
            Integer index = -1;
            PifElement element = new PifElement(code, index, type, atom);
            programInternalForm.add(element);
        }
        else if (separators.contains(atom))
        {
            Type type = Type._SEPARATOR;
            Integer code = nonSymbolCodeBase + keywords.size() + operators.size() + separators.indexOf(atom);
            Integer index = -1;
            PifElement element = new PifElement(code, index, type, atom);
            programInternalForm.add(element);
        }
        else if (identifierAutomata.verifySequence(atom))
        {
            if (atom.length() > 8)
                throw new Exception("Identifier \"" + atom + "\" is too long. " +
                                            getLocationFormattedString(position, lines));

            Type type = Type.IDENTIFIER;
            Integer index = getIndexFromSymbolTable(atom);

            PifElement element = new PifElement(identifierCode, index, type, atom);
            programInternalForm.add(element);
        }
        else if (constantAutomata.verifySequence(atom))
        {
            Type type = Type.__CONSTANT;
            Integer index = getIndexFromSymbolTable(atom);

            PifElement element = new PifElement(constantCode, index, type, atom);
            programInternalForm.add(element);
        }
        else
            throw new Exception("Invalid symbol \"" + "\". " +
                                        getLocationFormattedString(position, lines));
    }

    private Integer getIndexFromSymbolTable(String atom)
    {
        try
        {
            return symbols.searchByAtom(atom).getKey().getCode();
        }
        catch (NullPointerException ignored)
        {
            Integer index = symbols.size();
            symbols.insert(new Symbol(index, atom));
            return index;
        }
    }

}
