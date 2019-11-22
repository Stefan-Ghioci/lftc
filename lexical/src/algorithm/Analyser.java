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
        StringBuilder operatorBuffer = new StringBuilder();
        String sequence;
        String prefix;

        int iterator = 0;
        int position = 1;
        int lines = 1;

        StringBuilder allCharacters = new StringBuilder();
        byte[] bytes = reader.readAllBytes();

        for (byte aByte : bytes)
        {
            allCharacters.append((char) aByte);
        }

        while (iterator < allCharacters.length())
        {
            if (allCharacters.charAt(iterator) == '\r')
            {
                iterator += 2;
                position = 1;
                lines++;
                continue;
            }

            if (separators.contains(String.valueOf(allCharacters.charAt(iterator))))
            {
                classify(String.valueOf(allCharacters.charAt(iterator)), position, lines);
                iterator++;
                position++;
                continue;
            }

            if (operators.contains(String.valueOf(allCharacters.charAt(iterator))))
            {
                while (operators.contains(String.valueOf(allCharacters.charAt(iterator))))
                {
                    operatorBuffer.append(allCharacters.charAt(iterator));
                    iterator++;
                    position++;
                }
                if (operators.contains(operatorBuffer.toString()))
                {
                    classify(operatorBuffer.toString(), position, lines);
                    operatorBuffer.delete(0, operatorBuffer.length());
                    continue;
                }
                else
                    throw new Exception("Operator concatenation \"" + operatorBuffer.toString() + "\" is invalid. " +
                                                getLocationFormattedString(position, lines));
            }

            sequence = allCharacters.substring(iterator);

            prefix = identifierAutomata.getLongestPrefix(sequence);

            if (!prefix.equals("null"))
            {
                classify(prefix, position, lines);
                iterator += prefix.length();
                position += prefix.length();
                continue;
            }

            prefix = constantAutomata.getLongestPrefix(sequence);

            if (!prefix.equals("null"))
            {
                classify(prefix, position, lines);
                iterator += prefix.length();
                position += prefix.length();
                continue;
            }

            throw new Exception("Invalid character \"" + allCharacters.charAt(iterator) + "\". " +
                                        getLocationFormattedString(position, lines));
        }
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
