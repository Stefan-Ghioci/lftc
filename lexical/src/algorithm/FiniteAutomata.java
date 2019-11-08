package algorithm;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

public class FiniteAutomata
{
    private List<String> alphabet;
    private List<String> states;
    private String initialState;
    private List<String> finalStates;
    private String[][] transitions;


    public String getLongestPrefix(String sequence)
    {

        String prefix = "";
        for (int i = 0; i <= sequence.length(); i++)
        {
            String subSequence = sequence.substring(0, i);

            if (verifySequence(subSequence))
                prefix = subSequence;
        }
        if (prefix.isEmpty() && !finalStates.contains(initialState))
            return "null";

        return prefix;
    }

    public boolean verifySequence(String sequence)
    {
        String currentState = initialState;

        for (char symbol : sequence.toCharArray())
        {
            boolean transitionFound = false;

            String[] row = transitions[states.indexOf(currentState)];
            for (int i = 0; i < row.length; i++)
                if (String.valueOf(symbol).equals(row[i]))
                {
                    currentState = states.get(i);
                    transitionFound = true;
                }

            if (!transitionFound)
                return false;
        }

        return finalStates.contains(currentState);
    }

    public FiniteAutomata(String filename) throws IOException
    {
        BufferedReader reader = new BufferedReader(new FileReader(filename));

        alphabet = Arrays.asList(reader.readLine().split(" "));

        states = Arrays.asList(reader.readLine().split(" "));

        initialState = reader.readLine();

        finalStates = Arrays.asList(reader.readLine().split(" "));

        transitions = new String[states.size()][states.size()];

        for (String[] row : transitions)
        {
            Arrays.fill(row, "∅");
        }

        String line = "";
        while ((line = reader.readLine()) != null)
        {
            List<String> list = Arrays.asList(line.split(" "));

            String startState = list.get(0);
            String symbol = list.get(1);
            String endState = list.get(2);

            transitions[states.indexOf(startState)][states.indexOf(endState)] = symbol;
        }
    }

    public FiniteAutomata(List<String> alphabet,
                          List<String> states,
                          String initialState,
                          List<String> finalStates,
                          String[][] transitions)
    {
        this.alphabet = alphabet;
        this.states = states;
        this.initialState = initialState;
        this.finalStates = finalStates;
        this.transitions = transitions;
    }

    public List<String> getAlphabet()
    {
        return alphabet;
    }

    public List<String> getStates()
    {
        return states;
    }

    public String getInitialState()
    {
        return initialState;
    }

    public List<String> getFinalStates()
    {
        return finalStates;
    }

    public String[][] getTransitions()
    {
        return transitions;
    }
}
