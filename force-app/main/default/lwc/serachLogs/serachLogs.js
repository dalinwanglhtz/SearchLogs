import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import searchLogs from '@salesforce/apex/SearchLogs.searchLogs';
import advancedSearchLogs from '@salesforce/apex/SearchLogs.advancedSearchLogs';
import getApiUser from '@salesforce/apex/SearchLogs.hasApiUser';

export default class SerachLogs extends LightningElement {
    someData;
    error;
    isLoaded = true;
    readyForSearch = false;

    connectedCallback() {
        getApiUser()
            .then((result) => {
                this.readyForSearch = result; 
            })
            .catch((error) => {
                this.error = error;
            })
    }

    handerRegisterSuccess() {
        this.readyForSearch = true;
    }

    handleEnter(event) {
        // When you hit Enter key
        if(event.keyCode == 13) {
            this.handleSearch();
        }
    }

    handleSearch(event) {
        this.isLoaded = false;
        let searchText = this.template.querySelector('lightning-input').value;
        if(!searchText) {
            this.isLoaded = true;
            return;
        }
        if(event.target.label == 'Search') {
            searchLogs({searchStr : searchText})
                .then((result) => {
                    if(!result) {
                        this.dispatchEvent(new ShowToastEvent({
                            title: 'Error',
                            message: 'No results found',
                            variant: 'error'
                        }))
                    }
                    this.isLoaded = true;
                    this.someData = result;
                })
                .catch((error) => {
                    this.error = error;
                    this.isLoaded = true;
                });
        } else {
            advancedSearchLogs({searchStr : searchText})
            .then((result) => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success',
                    message: 'Log Search Initiated',
                    variant: 'success'
                }))
                this.isLoaded = true;
                this.someData = 'Check your email';
            })
            .catch((error) => {
                this.error = error;
                this.isLoaded = true;
            });
        }
    }

    async copyToClipboard() {
        let textForCopy = this.template.querySelector('textarea');
        if(!navigator.clipboard) {
            console.log('No Navigator Object, use old method');
            textForCopy.select();
            textForCopy.setSelectionRange(0, 999999);
            document.execCommand('copy');
            textForCopy.value = '';
            return;
        }
        await navigator.clipboard.writeText(text);
    }

    downloadAsText() {
        if(!this.someData) return;
        console.log('About to download ...');
        let downloadElem = document.createElement('a');
        downloadElem.href = 'data:text/plain;charset=utf-8,' + encodeURIComponent(this.someData);
        downloadElem.target = '_self';
        downloadElem.download = 'debug-log.txt';
        document.body.appendChild(downloadElem);
        downloadElem.click();
        document.body.removeChild(downloadElem);
    }
}