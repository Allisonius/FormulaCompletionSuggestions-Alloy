import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

//helper class that writes results files containing integer values
public class ResultWriter {
    /**
     * Appends the integer value to the file located in filepath
     * @param filepath path to results .txt file
     * @param value integer value to be appended to the file
     */
    public static void writeResults(String filepath, int value) {
        try {
            FileWriter myWriter = new FileWriter(filepath, true);
            myWriter.write(Integer.toString(value) + '\n');
            myWriter.close();
        } catch (IOException e) {
            System.out.println("An error writing files occurred.");
            e.printStackTrace();
        }
    }

    public static void writeResults(String filepath, String value) {
        try {
            FileWriter myWriter = new FileWriter(filepath, true);
            myWriter.write(value + '\n');
            myWriter.close();
        } catch (IOException e) {
            System.out.println("An error writing files occurred.");
            e.printStackTrace();
        }
    }

}
