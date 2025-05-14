import { LightningElement, track } from 'lwc';
import getWeatherData from '@salesforce/apex/weatherAPI.getWeatherData';
 
export default class Weatherapi extends LightningElement {
    @track weatherData;
    @track error;
 
    // Method to call Apex method on button click
    handleGetWeatherClick() {
        getWeatherData()
            .then((result) => {
                console.log('Weather API Response:', result);  // Log the response for debugging
                this.weatherData = result;
                this.error = undefined;
            })
            .catch((error) => {
                console.error('Error:', error);
                this.error = error.body.message;
                this.weatherData = undefined;
            });
    }
}