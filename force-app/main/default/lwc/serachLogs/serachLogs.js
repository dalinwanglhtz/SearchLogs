import { LightningElement, wire } from 'lwc';
import searchLogs from '@salesforce/apex/SearchLogs.searchLogs';

export default class SerachLogs extends LightningElement {
    someData;
    isLoaded = true;

    handleEnter(event) {
        // When you hit Enter key
        if(event.keyCode == 13) {
            this.handleSearch();
        }
    }

    handleSearch() {
        this.isLoaded = false;
        let searchText = this.template.querySelector('lightning-input').value;
        if(!searchText) {
            this.isLoaded = true;
            return;
        }
        searchLogs({searchStr : searchText})
            .then((result) => {
                console.log('log data: ', result);
                this.isLoaded = true;
                this.someData = result;
            })
            .catch((error) => {
                this.isLoaded = true;
                console.log('Error with search: ', error);
            });
    }
}