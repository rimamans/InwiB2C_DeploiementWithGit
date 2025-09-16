import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';

import { loadStyle, loadScript } from 'lightning/platformResourceLoader';



import template from './inwiB2C_OCR_SCAN.html';

export default class InwiB2C_OCR_SCAN  extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
/*
    start() {
    
        var wsImpl = window.WebSocket || window.MozWebSocket;
     
        window.ws = new wsImpl('wss://localhost:8050/');
 
        ws.onconnection = function (e) {
         console.log('new client is here!');
        }
 
        ws.onerror = function (e) {
         console.log('onerror!');
        }
     }
*/
url = '';
    send_socket() {
        console.log('socket start');
        var wsImpl = window.WebSocket || window.MozWebSocket;
     
        window.ws = new wsImpl('wss://localhost:8050/');

        const webSocket = new WebSocket('wss://localhost:8050/');
    
    
        ws.addEventListener('close',(e)=>{
            console.log('close socket message');
        });
    
        ws.addEventListener('message',(e)=>{
            console.log('socket message');
    
            console.log('e.data: ');
            console.log(e.data);
    
            var image = new Image();
    
    image.src = e.data;
    try {
        this.url = e.data;


     } catch (error) {
        console.log("log error on insertion : ");
         console.error(error);
     }   
        // console.log(e);
        });
    
        ws.addEventListener('open',(e)=>{
            console.log('socket open');
            ws.send("msg from client ! ");
            console.log('msg sent open');
        });
    
        ws.addEventListener('error',(e)=>{
            console.log('socket error');
        });
    };


    connectedCallback() {
       // this.start();

        }

    



    render() {
        return template;
    }
}