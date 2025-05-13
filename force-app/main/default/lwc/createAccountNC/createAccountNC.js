/**
 * this component is used to create an account for passing the data accross the salesforce platforms
 * Example for rest integration with jabascript
 * @ author : Sudheer Kuamr
 */

import { LightningElement,track } from 'lwc';
import methodCallout from '@salesforce/apex/RestAPIIntegrationCalloutController.methodCallout';
import {ShowToastEvent}  from 'lightning/platformShowToastEvent';

export default class CreateAccountNC extends LightningElement {

    @track accName='';
    @track accList=[];
    @track Id=1;

    columns = [
        {label: 'Id', fieldName: 'Id'},
        { label: 'Name', fieldName: 'Name' }
    ]

    handleChange(event){
        const {name,value} = event.target;
        this[name] = value;
    }

    handleAdd(){
        this.accList= [...this.accList,
            {
                Id:this.Id++,
                Name:this.accName
            }
        ];
        console.log('SSS Printed List : ' , JSON.stringify(this.accList));
        this.accName='';
    }

    handleCreate() {
        
        methodCallout({JsonData : JSON.stringify(this.accList)})
        .then(result => {
            console.log('Result is: ', result);
            this.showToast('Success', 'Records created successfully!', 'success');
        })
        .catch(error => {
            console.error('Error creating account(s): ', error);
            
            let message = 'Unknown error';
            
            if (error.body && error.body.message) {
                message = error.body.message;
            } else if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            }
            
            this.showToast('Error', message, 'error');
        });
        this.accList = [];
        this.Id = 1;
    }
    
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
    
        this.dispatchEvent(event);
    }
    
}