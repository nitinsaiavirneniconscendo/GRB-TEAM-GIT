trigger OpportunityCDCApiTrigger on OpportunityChangeEvent (after insert ) {
        for (OpportunityChangeEvent evt : Trigger.New) {
        // Extract necessary values
        String opportunityId = evt.Id; 
        String name = evt.Name;
        Decimal amount = evt.Amount;
        String stageName = evt.StageName;
        Date closeDate = evt.CloseDate;
 
        // Get Change Type and check for create/update
        String changeType = evt.ChangeEventHeader.getChangeType();
        if (changeType == 'CREATE' || changeType == 'UPDATE') {
            OpportunityCDCService.sendOpportunityData(opportunityId, name, amount, stageName, closeDate);
        }
    }
}