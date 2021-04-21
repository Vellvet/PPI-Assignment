/*
 * THIS CLASS WILL BE ON THE API CLASS
 * JUST COPY AND REPLACE IT TO THE API CLASS
*/
import java.io.*;
import java.net.*;
import java.util.List;
import java.util.logging.Logger;

public class API 
{
    final String Domain ="https://opentdb.com/api.php?amount=1&category=9&type=multiple";
    String inputLine; 

    public String getAPIResult() {
        try {
            URL google = new URL(Domain);
            BufferedReader in = new BufferedReader(new InputStreamReader(google.openStream()));
            while ((inputLine = in.readLine()) != null) {
                // Process each line.
                return inputLine;
            }
            in.close();

        } catch (MalformedURLException me) {
            System.out.println(me); 

        } catch (IOException ioe) {
            System.out.println(ioe);
        }
        return null;
    }//end main
}
 
