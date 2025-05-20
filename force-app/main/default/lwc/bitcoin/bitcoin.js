import { LightningElement, track } from 'lwc';
import getBitcoinPrices from '@salesforce/apex/bitcoinPriceController.bitcoinPriceController1';

export default class BitcoinPriceComponent extends LightningElement {
    @track priceData;
    @track error;

    // Handle the button click
    handleGetPriceClick() {
        getBitcoinPrices()
            .then((result) => {
                console.log('API Response:', result);  // Log the full response
                this.priceData = result;  // Store the response data
                this.error = undefined;   // Clear any previous errors
            })
            .catch((error) => {
                console.error('Error:', error);  // Log the error for debugging
                this.error = error.body.message;
                this.priceData = undefined;  // Clear the data on error
            });
    }

    // Getter to safely access the price
    get price() {
        // Return the price if data exists
        return this.priceData && this.priceData[0] ? this.priceData[0].price : undefined;
    }
}