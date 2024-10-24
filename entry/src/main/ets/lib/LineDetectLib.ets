import http from '@ohos.net.http';

interface LineDetectDelegate {
  useTheLine(line: string): void;
  lineError(error: Result): void;
}

export class LineDetectLib {
  private delegate: LineDetectDelegate | null = null;
  private urlList: string[] = [];
   static usedLine = false;
   static retryTimes = 0;
  private bodyStr: { [key: string]: string } = {};
  //private bodyStr: Map<string, string> = new Map();
  private bodyStr: Json = new Json();
  private tenantId: number;


  constructor(urlStrings: string, delegate: LineDetectDelegate | null = null, tenantId: number) {
    this.delegate = delegate;
    this.urlList = urlStrings.split(",");
    LineDetectLib.usedLine = false;
    LineDetectLib.retryTimes = 0;
    this.tenantId = tenantId;
    //"wcs", tenantId

  }

  public getLine(): void {
    let foundLine = false;
    let myStep2Index = 0;
    this.bodyStr = { "gnsId": "wcs", "tenantId": 'tenantId' };
    for (const txtUrl of this.urlList) {
      if (LineDetectLib.usedLine) break;
      if (foundLine) break;

      const url = this.checkUrl(`${txtUrl}/v1/api/verify`);
      if (!url) {
        console.debug(`Invalid URL: ${txtUrl}`);
        continue;
      }

      const uuid = this.generateUUID();
      const headers = {
        "Content-Type": "application/json",
        "x-trace-id": uuid,
      };

      const httpRequest = http.createHttp();
      //let jsonStr: string = '{"gnsId": "wcs", "tenantId": "12345"}';

      //let jsonObject = JSON.parse(jsonStr);
      httpRequest.request(
        url,
        {
          method: http.RequestMethod.POST,
          extraData: this.bodyStr,
          header: headers,
          connectTimeout: 60000,
        },
        (err, data) => {
          if (err) {
            console.debug(`line: ${txtUrl} 失败`);
            myStep2Index++;
            if (myStep2Index === this.urlList.length) {
              this.failedAndRetry();
            }
          } else {
            if (data != null) {
              //let responseBody = JSON.parse(data);
              if (responseBody.tenantId === this.tenantId) {
                foundLine = true;

                if (!LineDetectLib.usedLine) {
                  LineDetectLib.usedLine = true;
                  let line = data.url;
                  const port = data.request.url.port;
                  if (port && port !== 80 && port !== 443) {
                    line = `${line}:${port}`;
                  }
                  this.delegate?.useTheLine(line);
                  console.debug(`Using line: ${line}`);
                }
              } else {
                console.debug(`Line failed: ${url}, invalid response data`);
                myStep2Index++;
                if (myStep2Index === this.urlList.length) {
                  this.failedAndRetry();
                }
              }
            }
          }
        }
      );
    }
  }

  private failedAndRetry(): void {
    if (LineDetectLib.usedLine) return;

    let result = new Result();
    if (LineDetectLib.retryTimes < 3) {
      LineDetectLib.retryTimes++;
      result.Code = 1009;
      result.Message = `Line acquisition failed, retry ${LineDetectLib.retryTimes}`;
      this.delegate?.lineError(result);
      this.getLine();
    } else {
      result.Code = 1008;
      result.Message = "No available line";
      this.delegate?.lineError(result);
    }
  }

  private checkUrl(str: string): string {
    const r = Math.floor(Math.random() * 100000);
    let newStr = str.trim();
    newStr = `${newStr}?${r}`;

    if (!newStr.startsWith("http")) {
      return "";
    }
    return newStr;
  }

  private generateUUID(): string {
    // Use a simple UUID generation function
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
      const r = (Math.random() * 16) | 0;
      const v = c === 'x' ? r : (r & 0x3) | 0x8;
      return v.toString(16);
    });
  }
}

export class Result {
  public Code: number = 0;
  public Message: string = "";
}
