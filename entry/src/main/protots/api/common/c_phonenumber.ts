/**
 * Generated by the protoc-gen-ts.  DO NOT EDIT!
 * compiler version: 5.26.1
 * source: api/common/c_phonenumber.proto
 * git: https://github.com/thesayyn/protoc-gen-ts */
import * as pb_1 from "google-protobuf";
export namespace api.common {
    export class PhoneNumber extends pb_1.Message {
        #one_of_decls: number[][] = [];
        constructor(data?: any[] | {
            country_code?: number;
            national_number?: number;
            masked_national_number?: string;
        }) {
            super();
            pb_1.Message.initialize(this, Array.isArray(data) ? data : [], 0, -1, [], this.#one_of_decls);
            if (!Array.isArray(data) && typeof data == "object") {
                if ("country_code" in data && data.country_code != undefined) {
                    this.country_code = data.country_code;
                }
                if ("national_number" in data && data.national_number != undefined) {
                    this.national_number = data.national_number;
                }
                if ("masked_national_number" in data && data.masked_national_number != undefined) {
                    this.masked_national_number = data.masked_national_number;
                }
            }
        }
        get country_code() {
            return pb_1.Message.getFieldWithDefault(this, 1, 0) as number;
        }
        set country_code(value: number) {
            pb_1.Message.setField(this, 1, value);
        }
        get national_number() {
            return pb_1.Message.getFieldWithDefault(this, 2, 0) as number;
        }
        set national_number(value: number) {
            pb_1.Message.setField(this, 2, value);
        }
        get masked_national_number() {
            return pb_1.Message.getFieldWithDefault(this, 3, "") as string;
        }
        set masked_national_number(value: string) {
            pb_1.Message.setField(this, 3, value);
        }
        static fromObject(data: {
            country_code?: number;
            national_number?: number;
            masked_national_number?: string;
        }): PhoneNumber {
            const message = new PhoneNumber({});
            if (data.country_code != null) {
                message.country_code = data.country_code;
            }
            if (data.national_number != null) {
                message.national_number = data.national_number;
            }
            if (data.masked_national_number != null) {
                message.masked_national_number = data.masked_national_number;
            }
            return message;
        }
        toObject() {
            const data: {
                country_code?: number;
                national_number?: number;
                masked_national_number?: string;
            } = {};
            if (this.country_code != null) {
                data.country_code = this.country_code;
            }
            if (this.national_number != null) {
                data.national_number = this.national_number;
            }
            if (this.masked_national_number != null) {
                data.masked_national_number = this.masked_national_number;
            }
            return data;
        }
        serialize(): Uint8Array;
        serialize(w: pb_1.BinaryWriter): void;
        serialize(w?: pb_1.BinaryWriter): Uint8Array | void {
            const writer = w || new pb_1.BinaryWriter();
            if (this.country_code != 0)
                writer.writeInt32(1, this.country_code);
            if (this.national_number != 0)
                writer.writeInt64(2, this.national_number);
            if (this.masked_national_number.length)
                writer.writeString(3, this.masked_national_number);
            if (!w)
                return writer.getResultBuffer();
        }
        static deserialize(bytes: Uint8Array | pb_1.BinaryReader): PhoneNumber {
            const reader = bytes instanceof pb_1.BinaryReader ? bytes : new pb_1.BinaryReader(bytes), message = new PhoneNumber();
            while (reader.nextField()) {
                if (reader.isEndGroup())
                    break;
                switch (reader.getFieldNumber()) {
                    case 1:
                        message.country_code = reader.readInt32();
                        break;
                    case 2:
                        message.national_number = reader.readInt64();
                        break;
                    case 3:
                        message.masked_national_number = reader.readString();
                        break;
                    default: reader.skipField();
                }
            }
            return message;
        }
        serializeBinary(): Uint8Array {
            return this.serialize();
        }
        static deserializeBinary(bytes: Uint8Array): PhoneNumber {
            return PhoneNumber.deserialize(bytes);
        }
    }
}
