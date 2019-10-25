package algorithm;

import data_structure.PifElement;
import data_structure.Type;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

public class Analyser
{
    private FileInputStream reader;

    private List<String> keywords;
    private List<String> operators;
    private List<String> separators;
    private List<PifElement> programInternalForm;

    private List<String> symbols;

    private String alphanumericRegex = "[a-zA-Z0-9]+";
    private String identifierRegex = "[a-zA-Z]+[0-9]*";
    private String constantRegex = "0|[1-9]+[0-9]*|\".*\"";

    public List<String> getSymbols()
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
        this.symbols = new ArrayList<>();
        loadSpecification();
        loadFile(file);
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

            if (character.matches(alphanumericRegex))
            {
                if (atom.matches(alphanumericRegex) || atom.isEmpty())
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
                if (atom.matches(alphanumericRegex))
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
        Integer nonSymbolCodeBase = 3;

        if (keywords.contains(atom))
        {
            Type type = Type.KEYWORD;
            Integer code = nonSymbolCodeBase + keywords.indexOf(atom);
            Integer index = -1;
            PifElement element = new PifElement(code, index, type);
            programInternalForm.add(element);
        }
        else if (operators.contains(atom))
        {
            Type type = Type.OPERATOR;
            Integer code = nonSymbolCodeBase + keywords.size() + operators.indexOf(atom);
            Integer index = -1;
            PifElement element = new PifElement(code, index, type);
            programInternalForm.add(element);
        }
        else if (separators.contains(atom))
        {
            Type type = Type.SEPARATOR;
            Integer code = nonSymbolCodeBase + keywords.size() + operators.size() + separators.indexOf(atom);
            Integer index = -1;
            PifElement element = new PifElement(code, index, type);
            programInternalForm.add(element);
        }
        else if (atom.matches(identifierRegex))
        {
            if (atom.length() > 8)
                throw new Exception("Identifier \"" + atom + "\" is too long. " +
                                            getLocationFormattedString(position, lines));

            Type type = Type.IDENTIFIER;
            Integer index = getIndexFromSymbolTable(atom);

            PifElement element = new PifElement(identifierCode, index, type);
            programInternalForm.add(element);
        }
        else if (atom.matches(constantRegex))
        {
            Type type = Type.CONSTANT;
            Integer index = getIndexFromSymbolTable(atom);

            PifElement element = new PifElement(constantCode, index, type);
            programInternalForm.add(element);
        }
        else
            throw new Exception("Invalid symbol \"" + "\". " +
                                        getLocationFormattedString(position, lines));
    }

    private Integer getIndexFromSymbolTable(String atom)
    {

        int index = symbols.indexOf(atom);
        if (index == -1)
        {
            symbols.add(atom);
            return symbols.indexOf(atom);
        }
        return index;
    }

}
