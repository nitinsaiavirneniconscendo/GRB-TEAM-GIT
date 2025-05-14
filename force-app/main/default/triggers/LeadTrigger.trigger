trigger LeadTrigger on Lead (after insert) {
    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

    for (Lead lead : Trigger.new) {
        if (lead.Create_Lead__c == true) {  // Check if checkbox is true
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[]{lead.Email}); // Change recipient
            mail.setSubject('New Lead Created: ' + lead.Name);
            mail.setPlainTextBody(
                'A new Lead has been created in Salesforce.\n\n' +
                'Lead Name: ' + lead.FirstName + ' ' + lead.LastName + '\n' +
                'Email: ' + lead.Email + '\n' +
                'Company: ' + lead.Company
                // If you want to include the Lead record URL, uncomment the next line
                // + '\n\nView Lead: ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + lead.Id
            );
            emails.add(mail);
        }
    }

    if (!emails.isEmpty()) {
        Messaging.sendEmail(emails);
    }
}