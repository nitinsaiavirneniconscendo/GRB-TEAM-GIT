import { LightningElement, api,track} from 'lwc';

export default class SampleChildCounter extends LightningElement {
    @api initialcount=0;
    @track count = 0;

  
    connectedCallback() {
        this.count = this.initialcount;
    }
    Increment() {
        this.count +=1;
        this.displayEvent(this.count);
    }
    Decrement() {
     if(this.count>0){
        this.count -=1;
        this.displayEvent(this.count);
     }

    }
        displayEvent(){
            const event = new CustomEvent('showcount',{
              detail: { newCount: this.count }
          });
          // this.dispatchEvent(event);
        }
        
get isDecrementDisabled() {
    return this.count === 0;
}

}