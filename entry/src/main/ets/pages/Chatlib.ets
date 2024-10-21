import { webSocket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import * as CMessage from '../../protots/api/common/c_message';
import * as GGateway from '../../protots/gateway/g_gateway';
import * as GPayload from '../../protots/gateway/g_payload';
import * as GAction from '../../protots/gateway/g_action';

//import { api } from '@api/common/c_device';

// Import necessary libraries for protobuf and WebSocket
import { listener } from './listener'; //
// Assuming you have a listener object for callbacks


export class Chatlib {

  private token: string | undefined;
  private payloadId: number | undefined;
  private isConnected: boolean = false;
  private chatId: string | undefined;
  private consultId: string | undefined;
  private sendingMessage: any;  // Define sendingMessage type properly
  private msgList: any;  // Define msgList type properly

  public connectWebSocket(): void {
    // let defaultIpAddress =
    // "wss://csapi.hfxg.xyz/v1/gateway/h5?cert=COYBEAUYASDyASiG2piD9zE.te46qua5ha2r-Caz03Vx2JXH5OLSRRV2GqdYcn9UslwibsxBSP98GhUKSGEI0Z84FRMkp16ZK8eS-y72QVE2AQ&token=&userid=666333&ty=104&dt=1714976421667&sign=9zgd9YUc&rd=1672306";

    let defaultIpAddress = "wss://echo.websocket.org"
    let ws = webSocket.createWebSocket()

    //let myDevice: api.common.DeviceType = api.common.DeviceType.Android;
    let msg = new CMessage.api.common.MessageContent()
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


  public receiveMsg(data: Uint8Array): void {
    // If the data has a length of 1 byte, we treat it as a specific signal
    if (data.length === 1) {
      const d = String.fromCharCode(...data); // Convert Uint8Array to string

      switch (d) {
        case "\u0000":
          console.log("Received heartbeat acknowledgment");
          break;
        case "\u0001":
          this.disConnected(1010, "Logged in from another location");
          console.log("Received signal 1: Logged in from another location");
          break;
        case "\u0002":
          this.disConnected(1002, "Invalid token");
          console.log("Received signal 2: Invalid token");
          break;
        case "\u0003":
          console.log("Received signal 3: Permission changed");
          break;
        default:
          console.log(`Received signal: ${d}`);
      }
    } else {
      // Parsing the message using Protobuf
      const recvPayload = GPayload.gateway.Payload.deserializeBinary(data);
      const msgData = recvPayload.data;

      // Handle specific actions based on the received payload
      switch (recvPayload.act) {
        case GAction.gateway.Action.ActionSCRecvMsg:
          const recvMsg = GGateway.gateway.SCRecvMessage.deserializeBinary(data);
          if (recvMsg.msg.msg_op === CMessage.api.common.MessageOperate.MSG_OP_DELETE) {
            listener?.msgDeleted(recvMsg.msg, recvPayload.id, -1);
          } else {
            listener?.receivedMsg(recvMsg.msg);
          }
          break;

        case GAction.gateway.Action.ActionSCHi:
          const hiMsg = GGateway.gateway.SCHi.deserializeBinary(data);
          this.token = hiMsg.token;
          this.payloadId = recvPayload.id;
          console.log(`Initial payloadId: ${this.payloadId}`);
          listener?.connected(hiMsg);
          this.isConnected = true;
          this.startTimer();
          break;

        case GAction.gateway.Action.ActionForward:
          const forwardMsg = GGateway.gateway.CSForward.deserializeBinary(data);
          console.log(`Forward: ${forwardMsg.data}`);
          break;

        case GAction.gateway.Action.ActionSCDeleteMsgACK:
          const deleteMsgAck = GGateway.gateway.SCSendMessage.deserializeBinary(data);
          const msg = new CMessage.api.common.Message();
          msg.msg_id = deleteMsgAck.msg_id;
          msg.msg_op = CMessage.api.common.MessageOperate.MSG_OP_DELETE
          console.log(`Delete acknowledgment received: message ID: ${msg.msg_id}`);
          listener?.msgDeleted(msg, recvPayload.id, -1);
          break;

        case GAction.Action.ActionSCDeleteMsg:
          const deleteMsg = GGateway.SCRecvMessage.parseFrom(msgData);
          const msgDelete = CMessage.Message.newBuilder()
            .setMsgId(deleteMsg.msg.msgId)
            .setMsgOp(CMessage.MessageOperate.MSG_OP_DELETE)
            .build();
          listener?.msgDeleted(msgDelete, recvPayload.id, -1);
          console.log(`Message deleted by the other party: payload ID ${recvPayload.id}`);
          break;

        case GAction.Action.ActionSCSendMsgACK:
          const sendMsgAck = GGateway.SCSendMessage.parseFrom(msgData);
          this.chatId = sendMsgAck.chatId;
          console.log("Received message acknowledgment: ActionSCSendMsgACK");

          const cMsg = this.msgList[recvPayload.id];
          if (this.sendingMessage?.msgOp === CMessage.MessageOperate.MSG_OP_DELETE) {
            listener?.msgDeleted(cMsg, recvPayload.id, -1);
            console.log("Message deleted successfully");
          } else {
            listener?.msgReceipt(cMsg, recvPayload.id, sendMsgAck.msgId, sendMsgAck.errMsg);
          }
          console.log(`Message ID: ${sendMsgAck.msgId}`);
          break;

        case GAction.Action.ActionSCWorkerChanged:
          const workerChangedMsg = GGateway.SCWorkerChanged.parseFrom(msgData);
          this.consultId = workerChangedMsg.consultId;
          listener?.workChanged(workerChangedMsg);
          break;

        default:
          console.log(`Received unhandled data: ${data}`);
      }

  }

  // Additional methods used in the method, e.g., disConnected and startTimer
  private disConnected(code: number, reason: string): void {
    console.log(`Disconnected: ${code}, Reason: ${reason}`);
    // Add logic for handling disconnection
  }

  private startTimer(): void {
    console.log("Starting connection timer...");
    // Add logic for starting a timer
  }
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