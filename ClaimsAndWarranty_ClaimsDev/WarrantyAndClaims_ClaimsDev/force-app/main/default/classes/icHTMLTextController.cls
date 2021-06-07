public with sharing class icHTMLTextController {
    @auraEnabled
    public static String getFooterContent(String staticResourceName) {

        return [ SELECT
                Body
        FROM
                StaticResource
        WHERE
                Name = :staticResourceName
        ].Body.toString();

    }
    
}