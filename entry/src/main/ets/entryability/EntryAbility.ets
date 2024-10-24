import { AbilityConstant, StartupListener, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { Chatlib, Resp } from '../lib/Chatlib';
import * as CMessage from '../../protots/api/common/c_message';
import * as GGateway from '../../protots/gateway/g_gateway';
import * as GPayload from '../../protots/gateway/g_payload';
import * as GAction from '../../protots/gateway/g_action';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');

    let chat = new Chatlib("COYBEAUYASDyASiG2piD9zE.te46qua5ha2r-Caz03Vx2JXH5OLSRRV2GqdYcn9UslwibsxBSP98GhUKSGEI0Z84FRMkp16ZK8eS-y72QVE2AQ", "", 'wss://csapi.hfxg.xyz/v1/gateway/h5', 231, '655');
    chat.connectWebSocket();
    chat.listener = this;
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });


  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }

  // Received message
  receivedMsg(msg: CMessage.api.common.Message): void{

  }

  /**
   * Message receipt
   * @param msg - Sent message
   * @param payloadId
   * @param msgId - If 0, it means the server didn't generate a message ID, meaning sending failed
   * @param errMsg - Error message
   */
  msgReceipt(msg: CMessage.api.common.Message | null, payloadId: number, msgId: number, errMsg: string): void{

  }

  /**
   * Message deletion receipt
   * @param msg - Sent message
   * @param payloadId
   * @param msgId
   */
  msgDeleted(msg: CMessage.api.common.Message | null, payloadId: number, msgId: number): void{

  }

  /**
   * System message for displaying a tip
   * @param msg
   */
  systemMsg(msg: Resp<null>): void{
    if (msg.code == 1002 || msg.code == 1010 || msg.code == 1005){

    }else{
      console.log("已断开")
    }
  }

  /**
   * Connection success callback
   * @param SCHi
   */
  connected(c: GGateway.gateway.SCHi): void{

  }

  // Work change callback
  workChanged(msg: GGateway.gateway.SCWorkerChanged): void{

  }
}
