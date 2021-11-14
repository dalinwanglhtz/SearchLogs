import { LightningElement, wire } from 'lwc';
import searchLogs from '@salesforce/apex/SearchLogs.searchLogs';

export default class SerachLogs extends LightningElement {
    someData;

    handleSearch() {
        searchLogs({searchStr : 'australia'})
            .then((result) => {
                console.log('log data: ', result);
                this.someData = result;
            })
            .catch((error) => {
                console.log('Error with search: ', error);
            })
    }
}