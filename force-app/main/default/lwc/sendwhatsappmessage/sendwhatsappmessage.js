import { LightningElement, api } from 'lwc';
import sendTemplateMessage from '@salesforce/apex/WhatsAppTemplateMessageSender.sendTemplateMessage';
 
export default class Sendwhatsappmessage extends LightningElement {
    @api recordId;
 
    handleClick() {
        sendTemplateMessage({ contactId: this.recordId })
            .then(result => {
                alert('Result: ' + result);
            })
            .catch(error => {
                alert('Error: ' + error.body.message);
            });
    }
}