@RestResource(urlMapping='/getDatafromCase/')
global class Caseexample {
    @httpget
    global static List<Case> getCaseData(){
        
        Map<string, string> inputparams = RestContext.request.params;
        List<Case> caseLst = [Select id, Origin, CaseNumber, priority from Case WHERE priority = : inputparams.get('priority')];
        return caseLst;
    }
}