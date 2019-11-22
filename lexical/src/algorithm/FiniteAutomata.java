package algorithm;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class FiniteAutomata
{
    private List<String> alphabet;
    private List<String> states;
    private String initialState;
    private List<String> finalStates;
    private List<List<List<String>>> transitions;


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

    boolean verifySequence(String sequence)
    {
        String currentState = initialState;

        for (char symbol : sequence.toCharArray())
        {
            boolean transitionFound = false;

            List<List<String>> row = transitions.get(states.indexOf(currentState));
            for (int i = 0; i < row.size(); i++)
                if (row.get(i).contains(String.valueOf(symbol)))
                {
                    currentState = states.get(i);
                    transitionFound = true;
                }

            if (!transitionFound)
                return false;
        }

        return finalStates.contains(currentState);
    }

    FiniteAutomata(String filename) throws IOException
    {
        BufferedReader reader = new BufferedReader(new FileReader(filename));

        alphabet = Arrays.asList(reader.readLine().split(" "));

        states = Arrays.asList(reader.readLine().split(" "));

        initialState = reader.readLine();

        finalStates = Arrays.asList(reader.readLine().split(" "));

        transitions = new ArrayList<>();

        for (int i = 0; i < states.size(); i++)
        {
            transitions.add(new ArrayList<>());
            for (int j = 0; j < states.size(); j++)
                transitions.get(i).add(new ArrayList<>());
        }

        String line;
        while ((line = reader.readLine()) != null)
        {
            List<String> list = Arrays.asList(line.split(" "));

            String startState = list.get(0);
            String[] symbols = list.get(1).split(",");
            String endState = list.get(2);

            transitions.get(states.indexOf(startState)).get(states.indexOf(endState)).addAll(Arrays.asList(symbols));
        }
    }

    public FiniteAutomata(List<String> alphabet,
                          List<String> states,
                          String initialState,
                          List<String> finalStates,
                          List<List<List<String>>> transitions)
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

    List<List<List<String>>> getTransitions()
    {
        return transitions;
    }

    void setTransitions(List<List<List<String>>> transitions)
    {
        this.transitions = transitions;
    }
}
