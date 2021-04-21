
public class QuestionAPI
{
    

    public String request()
    {
        API API = new API();
        String APIResult = API.getAPIResult();

        return APIResult;
    }
    public String find(String APIResult, String keyword, int space)
    {
        int startnum = APIResult.indexOf(keyword);
        String find = "";
        for (int i = 0; i < 999; i++)
        {
            if((""+ APIResult.charAt(startnum + space + i)).equals(("\"")))
            {
                break;
            } 
            else
            find = find + APIResult.charAt(startnum + space + i) + "";
        }
        return find;
    }
    public String findArray(String APIResult, String keyword, int space)
    {
        int startnum = APIResult.indexOf(keyword);
        String find = "";
        for (int i = 0; i < 999; i++)
        {
            if((""+ APIResult.charAt(startnum + space + i)).equals(("]")))
            {
                break;
            } 
            else
            find = find + APIResult.charAt(startnum + space + i) + "";
        }
        return find.replace("\"","");
    }
    public String getQuestion(String APIResult)
    {
        return find(APIResult,"question",11);
    }
    public String getCorrectAnswer(String APIResult)
    {
        return find(APIResult,"correct_answer",17);
    }
    public String[] getIncorrectAnswers(String APIResult)
    {
        String InccorectArray = findArray(APIResult,"incorrect_answers",21);
        String ArrayAnswer[] = InccorectArray.split(",");
        return ArrayAnswer;
    }
}
