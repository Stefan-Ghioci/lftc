import algorithm.Analyser;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;

public class Main
{

    public static void main(String[] args) throws IOException
    {
        File input = null;
        Analyser analyser = null;

        while (true)
        {
            System.out.println();
            System.out.println("Choose a problem:");
            System.out.println("1. Perimeter and area");
            System.out.println("2. Sum of n given numbers");
            System.out.println("3. Greatest Common Divisor");
            System.out.println("x. Exit");


            BufferedReader reader =
                    new BufferedReader(new InputStreamReader(System.in));

            String problem = reader.readLine();
            switch (problem)
            {
                case "1":
                    input = new File("resources/per_area/");
                    break;
                case "2":
                    input = new File("resources/nsum/");
                    break;
                case "3":
                    input = new File("resources/gcd/");
                    break;
                case "x":
                    System.exit(0);
                default:
                    continue;
            }
            try
            {
                analyser = new Analyser(input);
                analyser.analyse();

                System.out.println("------PROGRAM INTERNAL FORM------");
                analyser.getProgramInternalForm().forEach(System.out::println);


                System.out.println("----------SYMBOLS TABLE----------");
                analyser.getSymbols().printInOrder();

            }
            catch (Exception e)
            {
                System.out.println("ERROR:" + e.getMessage());
            }
        }
    }
}
