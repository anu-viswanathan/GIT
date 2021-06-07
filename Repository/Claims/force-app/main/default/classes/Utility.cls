/*********************************************************
*        Name        :        Utility
*        Author      :        Shivram Saini
*        Date        :        14 Feb 2018
*        Description :        Created this class to contain commonly used methods separately
**********************************************************/
public class Utility{

    
    /*********************
    @ Shivram Saini
    @ 14 Feb 2018
    @ Prse date from string (yyyy-mm-dd)
    *********************/
    public static date parseDate(String dateStr){
        Date dt;
        if(dateStr !=null){
            List<String> dtList = dateStr.split('-');
            if(dtList.size()==3){
                dt = date.newInstance(integer.valueOf(dtList[0]),integer.valueOf(dtList[1]),integer.valueOf(dtList[2]));
            }    
        }
        return dt;    
    }
    
    /*********************
    @ Shivram Saini
    @ 14 Feb 2018
    @ Prse datetime from string (yyyy-mm-ddThh:mm:ss.SSS)
    *********************/
    public static datetime parseDateTimeGMT(String dateStr){
        DateTime dt;
        if(dateStr !=null){
            dateStr = dateStr.replace('T',' ');
            dt = DateTime.valueOfGmt(dateStr.split('\\.')[0]);       
        }
        return dt;    
    }
    
    
}