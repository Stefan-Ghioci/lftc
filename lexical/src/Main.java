import algorithm.FiniteAutomata;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Arrays;
import java.util.List;

public class Main
{

    public static void main(String[] args)
    {
        FiniteAutomata automata = null;

        try (BufferedReader consoleReader = new BufferedReader(new InputStreamReader(System.in)))
        {
            while (true)
            {
                printMenu();

                System.out.println("Enter command:");
                String command = consoleReader.readLine();

                try
                {
                    switch (command)
                    {
                        case "1":
                            automata = initializeDfaFromFile(consoleReader);
                            break;
                        case "2":
                            automata = initializeDfaFromConsole(consoleReader);
                            break;
                        case "3":
                            printDfaElements(consoleReader, automata);
                            break;
                        case "4":
                            verifySequence(consoleReader, automata);
                            break;
                        case "5":
                            getLongestPrefix(consoleReader, automata);
                            break;
                        case "0":
                            System.out.println("Exiting...");
                            return;
                        default:
                            System.out.println("Invalid command.");
                            break;
                    }
                }
                catch (NullPointerException ignored)
                {
                    System.out.println("Initialize DFA before executing other commands.");
                }
                catch (IOException e)
                {
                    System.out.println(e.getLocalizedMessage());
                }
            }

        }
        catch (IOException e)
        {
            e.printStackTrace();
        }

    }

    private static void getLongestPrefix(BufferedReader consoleReader, FiniteAutomata automata) throws IOException
    {
        System.out.println("Enter sequence:");
        String sequence = consoleReader.readLine();

        System.out.println("Longest prefix is: " + automata.getLongestPrefix(sequence));
    }

    private static void verifySequence(BufferedReader consoleReader, FiniteAutomata automata) throws IOException
    {
        System.out.println("Enter sequence:");
        String sequence = consoleReader.readLine();

        boolean accepted = automata.verifySequence(sequence);

        if (accepted)
            System.out.println("Sequence is accepted.");
        else
            System.out.println("Sequence is not accepted.");
    }

    private static void printSelectedElements(String command, FiniteAutomata automata)
    {
        switch (command)
        {
            case "1":
                automata.getAlphabet().forEach(symbol -> System.out.print(symbol + " "));
                System.out.println();
                break;
            case "2":
                automata.getStates().forEach(symbol -> System.out.print(symbol + " "));
                System.out.println();
                break;
            case "3":
                System.out.println(automata.getInitialState());
                break;
            case "4":
                automata.getFinalStates().forEach(symbol -> System.out.print(symbol + " "));
                System.out.println();
                break;
            case "5":
                List<String> alphabet = automata.getAlphabet();
                List<String> states = automata.getStates();
                String[][] transitions = automata.getTransitions();

                System.out.print("S\t");
                alphabet.forEach(symbol -> System.out.print(symbol + "\t"));
                System.out.println();


                for (int i = 0; i < states.size(); i++)
                {
                    System.out.print(states.get(i) + "\t");

                    for (String symbol : alphabet)
                        for (int k = 0; k < transitions[i].length; k++)
                            if (transitions[i][k].equals(symbol))
                                System.out.print(states.get(k) + "\t");

                    System.out.println();
                }
                break;
            default:
                System.out.println("Invalid command.");
                break;
        }
    }

    private static void printDfaElements(BufferedReader consoleReader, FiniteAutomata automata) throws IOException
    {
        printDfaElementsSubMenu();
        System.out.println("Enter command:");
        String command = consoleReader.readLine();
        printSelectedElements(command, automata);
    }

    private static void printDfaElementsSubMenu()
    {
        System.out.println("1. Print alphabet");
        System.out.println("2. Print states");
        System.out.println("3. Print initial state");
        System.out.println("4. Print final states");
        System.out.println("5. Print transitions");
    }

    private static FiniteAutomata initializeDfaFromConsole(BufferedReader consoleReader) throws IOException
    {
        System.out.println("Enter alphabet:");
        List<String> alphabet = Arrays.asList(consoleReader.readLine().split(" "));

        System.out.println("Enter states:");
        List<String> states = Arrays.asList(consoleReader.readLine().split(" "));

        System.out.println("Enter initial state:");
        String initialState = consoleReader.readLine();

        System.out.println("Enter final states:");
        List<String> finalStates = Arrays.asList(consoleReader.readLine().split(" "));

        System.out.println("Enter transitions (enter empty line to stop):");
        String[][] transitions = new String[states.size()][states.size()];

        for (String[] row : transitions)
        {
            Arrays.fill(row, "∅");
        }

        String line = consoleReader.readLine();
        while (!line.isBlank())
        {
            List<String> list = Arrays.asList(line.split(" "));

            String startState = list.get(0);
            String symbol = list.get(1);
            String endState = list.get(2);

            transitions[states.indexOf(startState)][states.indexOf(endState)] = symbol;
            line = consoleReader.readLine();
        }
        return new FiniteAutomata(alphabet, states, initialState, finalStates, transitions);
    }

    private static FiniteAutomata initializeDfaFromFile(BufferedReader consoleReader) throws IOException
    {
        System.out.println("Enter filename:");
        String filename = consoleReader.readLine();
        return new FiniteAutomata(filename);
    }

    private static void printMenu()
    {
        System.out.println("------------------------------------------");
        System.out.println("1. Initialize DFA from file");
        System.out.println("2. Initialize DFA from console");
        System.out.println("3. Print DFA elements");
        System.out.println("4. Verify given sequence");
        System.out.println("5. Get longest prefix from given sequence");
        System.out.println("0. Exit");
        System.out.println("------------------------------------------");
    }
}
