import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getUserName from '@salesforce/apex/SearchLogs.getUserName';
import getApiUser from '@salesforce/apex/SearchLogs.getApiUser';
import apiUserRegister from '@salesforce/apex/SearchLogs.apiUserRegister';
import deleteApiUser from '@salesforce/apex/SearchLogs.deleteApiUser';

export default class ApiUserEdit extends LightningElement {
    @track apiUser = {}
    error;

    handleInputChange(event) {
        this.apiUser[event.target.name] = event.target.value;
    }

    connectedCallback() {
        getUserName()
            .then(result => {
                getApiUser({userName: result})
                    .then(result => {
                        this.apiUser.Id = result.Id;
                        this.apiUser.Username__c = result.Username__c;
                        this.apiUser.Password__c = result.Password__c;
                        this.apiUser.Client_ID__c = result.Client_ID__c;
                        this.apiUser.Client_Secret__c = result.Client_Secret__c;
                    })
                    .catch(err => {
                        this.error = err.body.message;
                        this.showErrorMessage();
                    })
            })
            .catch(err => {
                this.error = err.body.message;
                this.showErrorMessage();
            });
    }

    showErrorMessage() {
        this.dispatchEvent(new ShowToastEvent({
            title: 'Error',
            message: this.error,
            variant: 'error'
        }));
    }

    handleSave() {
        this.registerApiUser(JSON.parse(JSON.stringify(this.apiUser)));
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

    handleDelete() {
        deleteApiUser({apiUser: JSON.parse(JSON.stringify(this.apiUser))})
            .then((result) => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success',
                    message: 'Api User Successfully Removed',
                    variant: 'success'
                }));
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