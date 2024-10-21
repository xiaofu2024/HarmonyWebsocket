import { webSocket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import * as cmessage from '../../protots/api/common/c_message';
import * as cgateway from '../../protots/gateway/g_gateway';
import { api } from '@api/common/c_device';


//import { api } from './././protots/api/common/c_device';  // Adjust the path to point to your .ts file
//import { api } from 'src/main/protots/api/common/c_asset.ts';
//src/main/ets/pages/Chatlib.ets

export class Chatlib {

  public connectWebSocket(): void {
   // let defaultIpAddress =
     // "wss://csapi.hfxg.xyz/v1/gateway/h5?cert=COYBEAUYASDyASiG2piD9zE.te46qua5ha2r-Caz03Vx2JXH5OLSRRV2GqdYcn9UslwibsxBSP98GhUKSGEI0Z84FRMkp16ZK8eS-y72QVE2AQ&token=&userid=666333&ty=104&dt=1714976421667&sign=9zgd9YUc&rd=1672306";

   let defaultIpAddress = "wss://echo.websocket.org"
    let ws = webSocket.createWebSocket()

    //let myDevice: api.common.DeviceType = api.common.DeviceType.Android;
let msg = new cmessage.api.common.MessageContent()
    msg.data = ""

   // let g = new cgateway.gateway.SCSendMessage.fromObject(null);

    //let d = api.common.;
    // Handle the open connection event
    ws.on('open', (err: BusinessError, value: Object) => {
      if (err) {
        console.error("Connection error: " + JSON.stringify(err));
        return;
      }
      console.log("WebSocket connection opened");

      // Send a message after the connection opens
      ws.send("Hello, server!", (err: BusinessError, value: boolean) => {
        if (err) {
          console.error("Send fail, err: " + JSON.stringify(err));
        } else {
          console.log("Send success");
        }
      });
    });

    // Handle incoming messages from the server
    ws.on('message', (err: BusinessError, value: string | ArrayBuffer) => {
      if (err) {
        console.error("Message error: " + JSON.stringify(err));
        return;
      }
      console.log("Received message: " + value);

      // If the message is 'bye', close the WebSocket
      if (value === 'bye') {
        this.closeWebSocket(ws);
      }
    });

    // Handle the close event
    ws.on('close', (err: BusinessError, value: webSocket.CloseResult) => {
      if (err) {
        console.error("Close event error: " + JSON.stringify(err));
      } else {
        console.log(`Connection closed with code: ${value.code}, reason: ${value.reason}`);
      }
    });

    // Handle WebSocket errors
    ws.on('error', (err: BusinessError) => {
      console.error("WebSocket error: " + JSON.stringify(err));
    });


    // Connect to the WebSocket server
    ws.connect(defaultIpAddress, {}, (err: BusinessError, value: boolean) => {
      if (err) {
        console.error("Connection fail, err: " + JSON.stringify(err));
      } else {
        console.log("Connection successful");
      }
    });

  }

  // Function to handle closing the WebSocket
  private closeWebSocket(ws: webSocket.WebSocket): void {
    ws.close((err: BusinessError, value: boolean) => {
      if (err) {
        console.error("Close fail, err: " + JSON.stringify(err));
      } else {
        console.log("WebSocket connection closed successfully");
      }
    });
  }


  public  connect(): Promise<boolean> {
    let defaultIpAddress =
     "wss://csapi.hfxg.xyz/v1/gateway/h5?cert=COYBEAUYASDyASiG2piD9zE.te46qua5ha2r-Caz03Vx2JXH5OLSRRV2GqdYcn9UslwibsxBSP98GhUKSGEI0Z84FRMkp16ZK8eS-y72QVE2AQ&token=&userid=666333&ty=104&dt=1714976421667&sign=9zgd9YUc&rd=1672306";

    //let defaultIpAddress = "wss://echo.websocket.org"
    return new Promise((resolve, reject) => {

         let socket = webSocket.createWebSocket()
          let promise = socket.connect(defaultIpAddress,{})
          promise.then(() => {
            socket.on('message', (err: BusinessError, value: string | ArrayBuffer) => {
              if (err) {
                console.error("Message error: " + JSON.stringify(err));
                return;
              }
              console.log("Received message: " + value);

              // If the message is 'bye', close the WebSocket
              if (value === 'bye') {
                this.closeWebSocket(socket);
              }
            });
          })
    })
  }
}