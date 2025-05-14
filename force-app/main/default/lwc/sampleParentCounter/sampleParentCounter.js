import { LightningElement } from 'lwc';

export default class SampleParentCounter extends LightningElement {
 Count=5;
 handleCountChange(event) {
        this.currentCount = event.detail.newCount;
    }
}