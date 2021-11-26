import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import USER_ID from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/User.Name';
import apiUserRegister from '@salesforce/apex/SearchLogs.apiUserRegister';

export default class ApiUserRegister extends LightningElement {
    error;

    @wire(getRecord, {
        recordId: USER_ID,
        fields: [NAME_FIELD]
    }) userRecord;

    get username() {
        return this.userRecord.data.fields.Name.value;
    }

    handleRegister() {
        let apiUser = {}
        let inputs = this.template.querySelectorAll('lightning-input');
        inputs.forEach(element => {
            if(element.name == 'username') {
                apiUser.Username__c = element.value;
            } else if(element.name == 'password') {
                apiUser.Password__c = element.value;
            } else if(element.name == 'clientId') {
                apiUser.Client_ID__c = element.value;
            } else if(element.name == 'clientSecret') {
                apiUser.Client_Secret__c = element.value;
            }
        });
        this.registerApiUser(apiUser);
    }

    registerApiUser(apiUser) {
        apiUserRegister({apiUser: apiUser})
            .then((result) => {
                this.dispatchEvent(new CustomEvent('registersuccess'));
            })
            .catch((error) => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error',
                    message: error.body.message,
                    variant: 'error'
                }));
            })
    }
}