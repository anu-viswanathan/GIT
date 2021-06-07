/**
 * Created by Andrea Pissinis on 2020-04-02.
 */

public with sharing class icAvoidRecursion {
    private static boolean run = true;
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
}