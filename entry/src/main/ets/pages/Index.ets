import { Chatlib } from './Chatlib'

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .onClick(()=>{
            //
            let chat = new Chatlib();
            let d = chat.connectWebSocket();
          })
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }

}