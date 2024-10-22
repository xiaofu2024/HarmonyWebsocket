import { webSocket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import * as CMessage from '../../protots/api/common/c_message';
import * as GGateway from '../../protots/gateway/g_gateway';
import * as GPayload from '../../protots/gateway/g_payload';
import * as GAction from '../../protots/gateway/g_action';
import { ArrayList, List } from '@kit.ArkTS';
import { Action } from '@kit.InputKit';
import { gateway } from '../../protots/gateway/g_payload';

//import { api } from '@api/common/c_device';

// Import necessary libraries for protobuf and WebSocket
//import { listener } from './listener'; //
// Assuming you have a listener object for callbacks

interface TeneasySDKDelegate {
  // Received message
  receivedMsg(msg: CMessage.api.common.Message): void;

  /**
   * Message receipt
   * @param msg - Sent message
   * @param payloadId
   * @param msgId - If 0, it means the server didn't generate a message ID, meaning sending failed
   * @param errMsg - Error message
   */
  msgReceipt(msg: CMessage.api.common.Message | null, payloadId: number, msgId: number, errMsg: string): void;

  /**
   * Message deletion receipt
   * @param msg - Sent message
   * @param payloadId
   * @param msgId
   */
  msgDeleted(msg: CMessage.api.common.Message | null, payloadId: number, msgId: number): void;

  /**
   * System message for displaying a tip
   * @param msg
   */
  systemMsg(msg: Result): void;

  /**
   * Connection success callback
   * @param SCHi
   */
  connected(c: GGateway.gateway.SCHi): void;

  // Work change callback
  workChanged(msg: GGateway.gateway.SCWorkerChanged): void;
}


export class Chatlib {
  private TAG: string = "ChatLib";
  private baseUrl: string = "";
  public isConnected: boolean = false;

  // The current message entity sent
  public sendingMessage: CMessage.api.common.Message | null = null;
  private chatId: number = 0;
  private token: string | null = "";
  private cert: string | null = "";
  private userId: number = 0;
  private mySign: string | null = "";
  //private socket: WebSocketClient | null = null;
  private ws = webSocket.createWebSocket()
  public listener: TeneasySDKDelegate | null = null;
  public payloadId: number = 0;
  private msgList = new ArrayList<CMessage.api.common.Message>();
  public replyMsgId: number = 0;
  public consultId: number = 0;
  //private heartTimer: any | null = null; // You can replace with a suitable Timer in ArkTS
  private sessionTime: number = 0;
  private beatTimes: number = 0;
  private maxSessionMinutes: number = 9000000; // Set session limits (adjust as needed)
  private withAutoReply: CMessage.api.common.WithAutoReply | null = null;

  constructor(cert: string, token: string, baseUrl: string = "", userId: number, sign: string, chatID: number = 0) {
    this.chatId = chatID;
    if (token.length > 10) {
      this.token = token;
    }
    if (baseUrl.length > 10) {
      this.baseUrl = baseUrl;
    }

    this.userId = userId;
    this.mySign = sign;

    if (cert.length > 10) {
      this.cert = cert;
    }

    this.sessionTime = 0;
    this.beatTimes = 0;
  }

  public connectWebSocket(): void {
    // let defaultIpAddress =
    // "wss://csapi.hfxg.xyz/v1/gateway/h5?cert=COYBEAUYASDyASiG2piD9zE.te46qua5ha2r-Caz03Vx2JXH5OLSRRV2GqdYcn9UslwibsxBSP98GhUKSGEI0Z84FRMkp16ZK8eS-y72QVE2AQ&token=&userid=666333&ty=104&dt=1714976421667&sign=9zgd9YUc&rd=1672306";

    let defaultIpAddress = "wss://echo.websocket.org"


    //let myDevice: api.common.DeviceType = api.common.DeviceType.Android;
    let msg = new CMessage.api.common.MessageContent()
    msg.data = ""

    // let g = new cgateway.gateway.SCSendMessage.fromObject(null);

    //let d = api.common.;
    // Handle the open connection event
    this.ws.on('open', (err: BusinessError, value: Object) => {
      if (err) {
        console.error("Connection error: " + JSON.stringify(err));
        return;
      }
      console.log("WebSocket connection opened");

      // Send a message after the connection opens
      this.ws.send("Hello, server!", (err: BusinessError, value: boolean) => {
        if (err) {
          console.error("Send fail, err: " + JSON.stringify(err));
        } else {
          console.log("Send success");
        }
      });
    });

    // Handle incoming messages from the server
    this.ws.on('message', (err: BusinessError, value: string | ArrayBuffer) => {
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
    this.ws.on('close', (err: BusinessError, value: webSocket.CloseResult) => {
      if (err) {
        console.error("Close event error: " + JSON.stringify(err));
      } else {
        console.log(`Connection closed with code: ${value.code}, reason: ${value.reason}`);
      }
    });

    // Handle WebSocket errors
    this.ws.on('error', (err: BusinessError) => {
      console.error("WebSocket error: " + JSON.stringify(err));
    });


    // Connect to the WebSocket server
    this.ws.connect(defaultIpAddress, {}, (err: BusinessError, value: boolean) => {
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
            this.listener?.msgDeleted(recvMsg.msg, recvPayload.id, -1);
          } else {
            this.listener?.receivedMsg(recvMsg.msg);
          }
          break;

        case GAction.gateway.Action.ActionSCHi:
          const hiMsg = GGateway.gateway.SCHi.deserializeBinary(data);
          this.token = hiMsg.token;
          this.payloadId = recvPayload.id;
          console.log(`Initial payloadId: ${this.payloadId}`);
          this.listener?.connected(hiMsg);
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
          this.listener?.msgDeleted(msg, recvPayload.id, -1);
          break;

        case GAction.gateway.Action.ActionSCDeleteMsg:
          const deleteMsg = GGateway.gateway.SCRecvMessage.deserializeBinary(data);
          const msgDel = new CMessage.api.common.Message();
          msgDel.msg_id = deleteMsg.msg.chat_id
          msgDel.msg_op = CMessage.api.common.MessageOperate.MSG_OP_DELETE

          this.listener?.msgDeleted(msgDel, recvPayload.id, -1);
          console.log(`Message deleted by the other party: payload ID ${recvPayload.id}`);
          break;

        case GAction.gateway.Action.ActionSCSendMsgACK:
          const sendMsgAck = GGateway.gateway.SCSendMessage.deserializeBinary(data);
          this.chatId = sendMsgAck.chat_id;
          console.log("Received message acknowledgment: ActionSCSendMsgACK");

          const cMsg = this.msgList[recvPayload.id];
          if (this.sendingMessage?.msg_op === CMessage.api.common.MessageOperate.MSG_OP_DELETE) {
            this.listener?.msgDeleted(cMsg, recvPayload.id, -1);
            console.log("Message deleted successfully");
          } else {
            this.listener?.msgReceipt(cMsg, recvPayload.id, sendMsgAck.msg_id, sendMsgAck.err_msg);
          }
          console.log(`Message ID: ${sendMsgAck.msg_id}`);
          break;

        case GAction.gateway.Action.ActionSCWorkerChanged:
          const workerChangedMsg = GGateway.gateway.SCWorkerChanged.deserializeBinary(msgData);
          this.consultId = workerChangedMsg.consult_id;
          this.listener?.workChanged(workerChangedMsg);
          break;

        default:
          console.log(`Received unhandled data: ${data}`);
      }

    }
  }

  private sendTextMessage(txt: string){
    // 第一层
    let content = new CMessage.api.common.MessageContent()
    content.data = txt

    // 第二层, 消息主题
    let msg = new CMessage.api.common.Message()
    msg.consult_id = this.consultId
    msg.content = content
    msg.sender = 0
    //msg.payload = GPayload.gateway.Payload.Com
    msg.reply_msg_id = this.replyMsgId
    msg.chat_id = this.chatId
    msg.worker = 0

    msg.msg_time.seconds = Date.now() * 0.001;

    // 临时放到一个变量
    this.sendingMessage = msg
  }

  private sendImageMessage(txt: string){
    // 第一层
    let content = new CMessage.api.common.MessageImage()
    content.uri = txt

    // 第二层, 消息主题
    let msg = new CMessage.api.common.Message()
    msg.consult_id = this.consultId
    msg.image = content
    msg.sender = 0
    //msg.payload = GPayload.gateway.Payload.Com
    msg.reply_msg_id = this.replyMsgId
    msg.chat_id = this.chatId
    msg.worker = 0

    msg.msg_time.seconds = Date.now() * 0.001;

    // 临时放到一个变量
    this.sendingMessage = msg
  }


  private sendVideoMessage(txt: string){
    // 第一层
    let content = new CMessage.api.common.MessageVideo()
    content.uri = txt

    // 第二层, 消息主题
    let msg = new CMessage.api.common.Message()
    msg.consult_id = this.consultId
    msg.video = content
    msg.sender = 0
    //msg.payload = GPayload.gateway.Payload.Com
    msg.reply_msg_id = this.replyMsgId
    msg.chat_id = this.chatId
    msg.worker = 0

    msg.msg_time.seconds = Date.now() * 0.001;

    // 临时放到一个变量
    this.sendingMessage = msg
  }

  private doSend(payload_Id: number = 0){

    if (this.sendingMessage == null){
      return
    }

    if (this.withAutoReply != null){
      this.sendingMessage.with_auto_replies.push(this.withAutoReply)
    }

    // 第三层
    let cSendMsg = new GGateway.gateway.CSSendMessage()
    cSendMsg.msg = this.sendingMessage
    // Serialize to binary protobuf format:
    let cSendMsgData = cSendMsg.serializeBinary()

    // 第四层
    let payLoad = new GPayload.gateway.Payload()
    payLoad.data = cSendMsgData
    payLoad.act = GAction.gateway.Action.ActionCSSendMsg

    //payload_id != 0的时候，可能是重发，重发不需要+1
    if (this.sendingMessage.msg_op == CMessage.api.common.MessageOperate.MSG_OP_POST){
      this.payloadId += 1
      this.msgList[this.payloadId] = this.sendingMessage;
    }

    if (payload_Id != 0){
      payLoad.id = payload_Id
    }else{
      payLoad.id = this.payloadId
    }
    let binaryData = payLoad.serializeBinary()
    //send(binaryData: binaryData)
    // Send a message after the connection opens
    this.ws.send(binaryData, (err: BusinessError, value: boolean) => {
      if (err) {
        console.error("Send fail, err: " + JSON.stringify(err));
      } else {
        console.log("Send success");
      }
    });
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



// Function to handle closing the WebSocket
  private closeWebSocket(ws: webSocket.WebSocket): void {
    this.ws.close((err: BusinessError, value: boolean) => {
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

function Int64(timeIntervalSince1970: undefined): number {
  throw new Error('Function not implemented.');
}
