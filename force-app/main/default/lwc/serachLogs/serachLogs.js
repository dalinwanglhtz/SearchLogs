import { LightningElement, wire } from 'lwc';
import searchLogs from '@salesforce/apex/SearchLogs.searchLogs';

export default class SerachLogs extends LightningElement {
    someData;

    handleSearch() {
        let searchText = this.template.querySelector('lightning-input').value;
        if(!searchText) return;
        searchLogs({searchStr : searchText})
            .then((result) => {
                console.log('log data: ', result);
                this.someData = result;
            })
            .catch((error) => {
                console.log('Error with search: ', error);
            })
    }
}