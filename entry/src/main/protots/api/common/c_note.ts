/**
 * Generated by the protoc-gen-ts.  DO NOT EDIT!
 * compiler version: 5.26.1
 * source: api/common/c_note.proto
 * git: https://github.com/thesayyn/protoc-gen-ts */
import * as dependency_1 from "./../../google/protobuf/timestamp";
import * as dependency_2 from "./c_message";
import * as dependency_3 from "./../../google/protobuf/wrappers";
import * as pb_1 from "google-protobuf";
export namespace api.common {
    export class Note extends pb_1.Message {
        #one_of_decls: number[][] = [];
        constructor(data?: any[] | {
            raw?: dependency_2.api.common.Message;
            name?: string;
        }) {
            super();
            pb_1.Message.initialize(this, Array.isArray(data) ? data : [], 0, -1, [], this.#one_of_decls);
            if (!Array.isArray(data) && typeof data == "object") {
                if ("raw" in data && data.raw != undefined) {
                    this.raw = data.raw;
                }
                if ("name" in data && data.name != undefined) {
                    this.name = data.name;
                }
            }
        }
        get raw() {
            return pb_1.Message.getWrapperField(this, dependency_2.api.common.Message, 1) as dependency_2.api.common.Message;
        }
        set raw(value: dependency_2.api.common.Message) {
            pb_1.Message.setWrapperField(this, 1, value);
        }
        get has_raw() {
            return pb_1.Message.getField(this, 1) != null;
        }
        get name() {
            return pb_1.Message.getFieldWithDefault(this, 2, "") as string;
        }
        set name(value: string) {
            pb_1.Message.setField(this, 2, value);
        }
        static fromObject(data: {
            raw?: ReturnType<typeof dependency_2.api.common.Message.prototype.toObject>;
            name?: string;
        }): Note {
            const message = new Note({});
            if (data.raw != null) {
                message.raw = dependency_2.api.common.Message.fromObject(data.raw);
            }
            if (data.name != null) {
                message.name = data.name;
            }
            return message;
        }
        toObject() {
            const data: {
                raw?: ReturnType<typeof dependency_2.api.common.Message.prototype.toObject>;
                name?: string;
            } = {};
            if (this.raw != null) {
                data.raw = this.raw.toObject();
            }
            if (this.name != null) {
                data.name = this.name;
            }
            return data;
        }
        serialize(): Uint8Array;
        serialize(w: pb_1.BinaryWriter): void;
        serialize(w?: pb_1.BinaryWriter): Uint8Array | void {
            const writer = w || new pb_1.BinaryWriter();
            if (this.has_raw)
                writer.writeMessage(1, this.raw, () => this.raw.serialize(writer));
            if (this.name.length)
                writer.writeString(2, this.name);
            if (!w)
                return writer.getResultBuffer();
        }
        static deserialize(bytes: Uint8Array | pb_1.BinaryReader): Note {
            const reader = bytes instanceof pb_1.BinaryReader ? bytes : new pb_1.BinaryReader(bytes), message = new Note();
            while (reader.nextField()) {
                if (reader.isEndGroup())
                    break;
                switch (reader.getFieldNumber()) {
                    case 1:
                        reader.readMessage(message.raw, () => message.raw = dependency_2.api.common.Message.deserialize(reader));
                        break;
                    case 2:
                        message.name = reader.readString();
                        break;
                    default: reader.skipField();
                }
            }
            return message;
        }
        serializeBinary(): Uint8Array {
            return this.serialize();
        }
        static deserializeBinary(bytes: Uint8Array): Note {
            return Note.deserialize(bytes);
        }
    }
    export class Notes extends pb_1.Message {
        #one_of_decls: number[][] = [];
        constructor(data?: any[] | {
            notes?: Map<string, Note>;
        }) {
            super();
            pb_1.Message.initialize(this, Array.isArray(data) ? data : [], 0, -1, [], this.#one_of_decls);
            if (!Array.isArray(data) && typeof data == "object") {
                if ("notes" in data && data.notes != undefined) {
                    this.notes = data.notes;
                }
            }
            if (!this.notes)
                this.notes = new Map();
        }
        get notes() {
            return pb_1.Message.getField(this, 1) as any as Map<string, Note>;
        }
        set notes(value: Map<string, Note>) {
            pb_1.Message.setField(this, 1, value as any);
        }
        static fromObject(data: {
            notes?: {
                [key: string]: ReturnType<typeof Note.prototype.toObject>;
            };
        }): Notes {
            const message = new Notes({});
            if (typeof data.notes == "object") {
                message.notes = new Map(Object.entries(data.notes).map(([key, value]) => [key, Note.fromObject(value)]));
            }
            return message;
        }
        toObject() {
            const data: {
                notes?: {
                    [key: string]: ReturnType<typeof Note.prototype.toObject>;
                };
            } = {};
            if (this.notes != null) {
                data.notes = (Object.fromEntries)((Array.from)(this.notes).map(([key, value]) => [key, value.toObject()]));
            }
            return data;
        }
        serialize(): Uint8Array;
        serialize(w: pb_1.BinaryWriter): void;
        serialize(w?: pb_1.BinaryWriter): Uint8Array | void {
            const writer = w || new pb_1.BinaryWriter();
            for (const [key, value] of this.notes) {
                writer.writeMessage(1, this.notes, () => {
                    writer.writeString(1, key);
                    writer.writeMessage(2, value, () => value.serialize(writer));
                });
            }
            if (!w)
                return writer.getResultBuffer();
        }
        static deserialize(bytes: Uint8Array | pb_1.BinaryReader): Notes {
            const reader = bytes instanceof pb_1.BinaryReader ? bytes : new pb_1.BinaryReader(bytes), message = new Notes();
            while (reader.nextField()) {
                if (reader.isEndGroup())
                    break;
                switch (reader.getFieldNumber()) {
                    case 1:
                        reader.readMessage(message, () => pb_1.Map.deserializeBinary(message.notes as any, reader, reader.readString, () => {
                            let value;
                            reader.readMessage(message, () => value = Note.deserialize(reader));
                            return value;
                        }));
                        break;
                    default: reader.skipField();
                }
            }
            return message;
        }
        serializeBinary(): Uint8Array {
            return this.serialize();
        }
        static deserializeBinary(bytes: Uint8Array): Notes {
            return Notes.deserialize(bytes);
        }
    }
}
