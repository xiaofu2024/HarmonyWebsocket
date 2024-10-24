//JSONUtils.ts
import { plainToClass, ClassConstructor, instanceToPlain } from "class-transformer";

export default class JSONUtils {
  /**
   * JSON字符串转Class对象
   * @param cls 类名
   * @param jsonStr json 字符串
   * @returns class对象
   */
  static json2Bean<T>(cls: ClassConstructor<T>, jsonStr: string): T | null {
    try {
      return plainToClass(cls, JSON.parse(jsonStr), {
        enableImplicitConversion: false, exposeDefaultValues: true
      }) as T
    } catch (e) {
      return null
    }
  }

  /**
   * 对象转字符串
   * @param data
   * @returns 字符串
   */
  static bean2Json(data: Object | Array<Object | String | Number | Boolean> | null | undefined): string {
    try {
      if (data == null || data == undefined) {
        return ''
      }
      return JSON.stringify(instanceToPlain(data))
    } catch (e) {
      return ""
    }
  }

  /**
   * JSON转Map
   * @param jsonStr
   * @returns
   */
  static json2Map(jsonStr: string): Map<string, Object> {
    return new Map(Object.entries(JSON.parse(jsonStr)));
  }
}