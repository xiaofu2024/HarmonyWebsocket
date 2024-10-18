/**
 * Generated by the protoc-gen-ts.  DO NOT EDIT!
 * compiler version: 5.26.1
 * source: api/core/tenant_group.proto
 * git: https://github.com/thesayyn/protoc-gen-ts */
import * as dependency_1 from "./../option";
import * as dependency_2 from "./../../google/protobuf/empty";
import * as dependency_3 from "./../../google/protobuf/timestamp";
import * as dependency_4 from "./../../validate/validate";
import * as dependency_5 from "./../common/c_worker";
import * as dependency_6 from "./../common/c_base";
import * as pb_1 from "google-protobuf";
import * as grpc_1 from "@grpc/grpc-js";
export namespace api.core {
    export class TenantCliqueQueryResponse extends pb_1.Message {
        #one_of_decls: number[][] = [];
        constructor(data?: any[] | {
            clique?: dependency_5.api.common.TenantClique[];
        }) {
            super();
            pb_1.Message.initialize(this, Array.isArray(data) ? data : [], 0, -1, [1], this.#one_of_decls);
            if (!Array.isArray(data) && typeof data == "object") {
                if ("clique" in data && data.clique != undefined) {
                    this.clique = data.clique;
                }
            }
        }
        get clique() {
            return pb_1.Message.getRepeatedWrapperField(this, dependency_5.api.common.TenantClique, 1) as dependency_5.api.common.TenantClique[];
        }
        set clique(value: dependency_5.api.common.TenantClique[]) {
            pb_1.Message.setRepeatedWrapperField(this, 1, value);
        }
        static fromObject(data: {
            clique?: ReturnType<typeof dependency_5.api.common.TenantClique.prototype.toObject>[];
        }): TenantCliqueQueryResponse {
            const message = new TenantCliqueQueryResponse({});
            if (data.clique != null) {
                message.clique = data.clique.map(item => dependency_5.api.common.TenantClique.fromObject(item));
            }
            return message;
        }
        toObject() {
            const data: {
                clique?: ReturnType<typeof dependency_5.api.common.TenantClique.prototype.toObject>[];
            } = {};
            if (this.clique != null) {
                data.clique = this.clique.map((item: dependency_5.api.common.TenantClique) => item.toObject());
            }
            return data;
        }
        serialize(): Uint8Array;
        serialize(w: pb_1.BinaryWriter): void;
        serialize(w?: pb_1.BinaryWriter): Uint8Array | void {
            const writer = w || new pb_1.BinaryWriter();
            if (this.clique.length)
                writer.writeRepeatedMessage(1, this.clique, (item: dependency_5.api.common.TenantClique) => item.serialize(writer));
            if (!w)
                return writer.getResultBuffer();
        }
        static deserialize(bytes: Uint8Array | pb_1.BinaryReader): TenantCliqueQueryResponse {
            const reader = bytes instanceof pb_1.BinaryReader ? bytes : new pb_1.BinaryReader(bytes), message = new TenantCliqueQueryResponse();
            while (reader.nextField()) {
                if (reader.isEndGroup())
                    break;
                switch (reader.getFieldNumber()) {
                    case 1:
                        reader.readMessage(message.clique, () => pb_1.Message.addToRepeatedWrapperField(message, 1, dependency_5.api.common.TenantClique.deserialize(reader), dependency_5.api.common.TenantClique));
                        break;
                    default: reader.skipField();
                }
            }
            return message;
        }
        serializeBinary(): Uint8Array {
            return this.serialize();
        }
        static deserializeBinary(bytes: Uint8Array): TenantCliqueQueryResponse {
            return TenantCliqueQueryResponse.deserialize(bytes);
        }
    }
    export class TenantCliqueCreateRequest extends pb_1.Message {
        #one_of_decls: number[][] = [];
        constructor(data?: any[] | {
            clique?: dependency_5.api.common.TenantClique;
        }) {
            super();
            pb_1.Message.initialize(this, Array.isArray(data) ? data : [], 0, -1, [], this.#one_of_decls);
            if (!Array.isArray(data) && typeof data == "object") {
                if ("clique" in data && data.clique != undefined) {
                    this.clique = data.clique;
                }
            }
        }
        get clique() {
            return pb_1.Message.getWrapperField(this, dependency_5.api.common.TenantClique, 1) as dependency_5.api.common.TenantClique;
        }
        set clique(value: dependency_5.api.common.TenantClique) {
            pb_1.Message.setWrapperField(this, 1, value);
        }
        get has_clique() {
            return pb_1.Message.getField(this, 1) != null;
        }
        static fromObject(data: {
            clique?: ReturnType<typeof dependency_5.api.common.TenantClique.prototype.toObject>;
        }): TenantCliqueCreateRequest {
            const message = new TenantCliqueCreateRequest({});
            if (data.clique != null) {
                message.clique = dependency_5.api.common.TenantClique.fromObject(data.clique);
            }
            return message;
        }
        toObject() {
            const data: {
                clique?: ReturnType<typeof dependency_5.api.common.TenantClique.prototype.toObject>;
            } = {};
            if (this.clique != null) {
                data.clique = this.clique.toObject();
            }
            return data;
        }
        serialize(): Uint8Array;
        serialize(w: pb_1.BinaryWriter): void;
        serialize(w?: pb_1.BinaryWriter): Uint8Array | void {
            const writer = w || new pb_1.BinaryWriter();
            if (this.has_clique)
                writer.writeMessage(1, this.clique, () => this.clique.serialize(writer));
            if (!w)
                return writer.getResultBuffer();
        }
        static deserialize(bytes: Uint8Array | pb_1.BinaryReader): TenantCliqueCreateRequest {
            const reader = bytes instanceof pb_1.BinaryReader ? bytes : new pb_1.BinaryReader(bytes), message = new TenantCliqueCreateRequest();
            while (reader.nextField()) {
                if (reader.isEndGroup())
                    break;
                switch (reader.getFieldNumber()) {
                    case 1:
                        reader.readMessage(message.clique, () => message.clique = dependency_5.api.common.TenantClique.deserialize(reader));
                        break;
                    default: reader.skipField();
                }
            }
            return message;
        }
        serializeBinary(): Uint8Array {
            return this.serialize();
        }
        static deserializeBinary(bytes: Uint8Array): TenantCliqueCreateRequest {
            return TenantCliqueCreateRequest.deserialize(bytes);
        }
    }
    export class TenantCliqueCreateResponse extends pb_1.Message {
        #one_of_decls: number[][] = [];
        constructor(data?: any[] | {
            clique?: dependency_5.api.common.TenantClique;
        }) {
            super();
            pb_1.Message.initialize(this, Array.isArray(data) ? data : [], 0, -1, [], this.#one_of_decls);
            if (!Array.isArray(data) && typeof data == "object") {
                if ("clique" in data && data.clique != undefined) {
                    this.clique = data.clique;
                }
            }
        }
        get clique() {
            return pb_1.Message.getWrapperField(this, dependency_5.api.common.TenantClique, 1) as dependency_5.api.common.TenantClique;
        }
        set clique(value: dependency_5.api.common.TenantClique) {
            pb_1.Message.setWrapperField(this, 1, value);
        }
        get has_clique() {
            return pb_1.Message.getField(this, 1) != null;
        }
        static fromObject(data: {
            clique?: ReturnType<typeof dependency_5.api.common.TenantClique.prototype.toObject>;
        }): TenantCliqueCreateResponse {
            const message = new TenantCliqueCreateResponse({});
            if (data.clique != null) {
                message.clique = dependency_5.api.common.TenantClique.fromObject(data.clique);
            }
            return message;
        }
        toObject() {
            const data: {
                clique?: ReturnType<typeof dependency_5.api.common.TenantClique.prototype.toObject>;
            } = {};
            if (this.clique != null) {
                data.clique = this.clique.toObject();
            }
            return data;
        }
        serialize(): Uint8Array;
        serialize(w: pb_1.BinaryWriter): void;
        serialize(w?: pb_1.BinaryWriter): Uint8Array | void {
            const writer = w || new pb_1.BinaryWriter();
            if (this.has_clique)
                writer.writeMessage(1, this.clique, () => this.clique.serialize(writer));
            if (!w)
                return writer.getResultBuffer();
        }
        static deserialize(bytes: Uint8Array | pb_1.BinaryReader): TenantCliqueCreateResponse {
            const reader = bytes instanceof pb_1.BinaryReader ? bytes : new pb_1.BinaryReader(bytes), message = new TenantCliqueCreateResponse();
            while (reader.nextField()) {
                if (reader.isEndGroup())
                    break;
                switch (reader.getFieldNumber()) {
                    case 1:
                        reader.readMessage(message.clique, () => message.clique = dependency_5.api.common.TenantClique.deserialize(reader));
                        break;
                    default: reader.skipField();
                }
            }
            return message;
        }
        serializeBinary(): Uint8Array {
            return this.serialize();
        }
        static deserializeBinary(bytes: Uint8Array): TenantCliqueCreateResponse {
            return TenantCliqueCreateResponse.deserialize(bytes);
        }
    }
    export class TenantCliqueUpdateRequest extends pb_1.Message {
        #one_of_decls: number[][] = [];
        constructor(data?: any[] | {
            clique?: dependency_5.api.common.TenantClique;
        }) {
            super();
            pb_1.Message.initialize(this, Array.isArray(data) ? data : [], 0, -1, [], this.#one_of_decls);
            if (!Array.isArray(data) && typeof data == "object") {
                if ("clique" in data && data.clique != undefined) {
                    this.clique = data.clique;
                }
            }
        }
        get clique() {
            return pb_1.Message.getWrapperField(this, dependency_5.api.common.TenantClique, 1) as dependency_5.api.common.TenantClique;
        }
        set clique(value: dependency_5.api.common.TenantClique) {
            pb_1.Message.setWrapperField(this, 1, value);
        }
        get has_clique() {
            return pb_1.Message.getField(this, 1) != null;
        }
        static fromObject(data: {
            clique?: ReturnType<typeof dependency_5.api.common.TenantClique.prototype.toObject>;
        }): TenantCliqueUpdateRequest {
            const message = new TenantCliqueUpdateRequest({});
            if (data.clique != null) {
                message.clique = dependency_5.api.common.TenantClique.fromObject(data.clique);
            }
            return message;
        }
        toObject() {
            const data: {
                clique?: ReturnType<typeof dependency_5.api.common.TenantClique.prototype.toObject>;
            } = {};
            if (this.clique != null) {
                data.clique = this.clique.toObject();
            }
            return data;
        }
        serialize(): Uint8Array;
        serialize(w: pb_1.BinaryWriter): void;
        serialize(w?: pb_1.BinaryWriter): Uint8Array | void {
            const writer = w || new pb_1.BinaryWriter();
            if (this.has_clique)
                writer.writeMessage(1, this.clique, () => this.clique.serialize(writer));
            if (!w)
                return writer.getResultBuffer();
        }
        static deserialize(bytes: Uint8Array | pb_1.BinaryReader): TenantCliqueUpdateRequest {
            const reader = bytes instanceof pb_1.BinaryReader ? bytes : new pb_1.BinaryReader(bytes), message = new TenantCliqueUpdateRequest();
            while (reader.nextField()) {
                if (reader.isEndGroup())
                    break;
                switch (reader.getFieldNumber()) {
                    case 1:
                        reader.readMessage(message.clique, () => message.clique = dependency_5.api.common.TenantClique.deserialize(reader));
                        break;
                    default: reader.skipField();
                }
            }
            return message;
        }
        serializeBinary(): Uint8Array {
            return this.serialize();
        }
        static deserializeBinary(bytes: Uint8Array): TenantCliqueUpdateRequest {
            return TenantCliqueUpdateRequest.deserialize(bytes);
        }
    }
    export class TenantCliqueDeleteRequest extends pb_1.Message {
        #one_of_decls: number[][] = [];
        constructor(data?: any[] | {
            clique_id?: number;
        }) {
            super();
            pb_1.Message.initialize(this, Array.isArray(data) ? data : [], 0, -1, [], this.#one_of_decls);
            if (!Array.isArray(data) && typeof data == "object") {
                if ("clique_id" in data && data.clique_id != undefined) {
                    this.clique_id = data.clique_id;
                }
            }
        }
        get clique_id() {
            return pb_1.Message.getFieldWithDefault(this, 1, 0) as number;
        }
        set clique_id(value: number) {
            pb_1.Message.setField(this, 1, value);
        }
        static fromObject(data: {
            clique_id?: number;
        }): TenantCliqueDeleteRequest {
            const message = new TenantCliqueDeleteRequest({});
            if (data.clique_id != null) {
                message.clique_id = data.clique_id;
            }
            return message;
        }
        toObject() {
            const data: {
                clique_id?: number;
            } = {};
            if (this.clique_id != null) {
                data.clique_id = this.clique_id;
            }
            return data;
        }
        serialize(): Uint8Array;
        serialize(w: pb_1.BinaryWriter): void;
        serialize(w?: pb_1.BinaryWriter): Uint8Array | void {
            const writer = w || new pb_1.BinaryWriter();
            if (this.clique_id != 0)
                writer.writeInt32(1, this.clique_id);
            if (!w)
                return writer.getResultBuffer();
        }
        static deserialize(bytes: Uint8Array | pb_1.BinaryReader): TenantCliqueDeleteRequest {
            const reader = bytes instanceof pb_1.BinaryReader ? bytes : new pb_1.BinaryReader(bytes), message = new TenantCliqueDeleteRequest();
            while (reader.nextField()) {
                if (reader.isEndGroup())
                    break;
                switch (reader.getFieldNumber()) {
                    case 1:
                        message.clique_id = reader.readInt32();
                        break;
                    default: reader.skipField();
                }
            }
            return message;
        }
        serializeBinary(): Uint8Array {
            return this.serialize();
        }
        static deserializeBinary(bytes: Uint8Array): TenantCliqueDeleteRequest {
            return TenantCliqueDeleteRequest.deserialize(bytes);
        }
    }
    interface GrpcUnaryServiceInterface<P, R> {
        (message: P, metadata: grpc_1.Metadata, options: grpc_1.CallOptions, callback: grpc_1.requestCallback<R>): grpc_1.ClientUnaryCall;
        (message: P, metadata: grpc_1.Metadata, callback: grpc_1.requestCallback<R>): grpc_1.ClientUnaryCall;
        (message: P, options: grpc_1.CallOptions, callback: grpc_1.requestCallback<R>): grpc_1.ClientUnaryCall;
        (message: P, callback: grpc_1.requestCallback<R>): grpc_1.ClientUnaryCall;
    }
    interface GrpcStreamServiceInterface<P, R> {
        (message: P, metadata: grpc_1.Metadata, options?: grpc_1.CallOptions): grpc_1.ClientReadableStream<R>;
        (message: P, options?: grpc_1.CallOptions): grpc_1.ClientReadableStream<R>;
    }
    interface GrpWritableServiceInterface<P, R> {
        (metadata: grpc_1.Metadata, options: grpc_1.CallOptions, callback: grpc_1.requestCallback<R>): grpc_1.ClientWritableStream<P>;
        (metadata: grpc_1.Metadata, callback: grpc_1.requestCallback<R>): grpc_1.ClientWritableStream<P>;
        (options: grpc_1.CallOptions, callback: grpc_1.requestCallback<R>): grpc_1.ClientWritableStream<P>;
        (callback: grpc_1.requestCallback<R>): grpc_1.ClientWritableStream<P>;
    }
    interface GrpcChunkServiceInterface<P, R> {
        (metadata: grpc_1.Metadata, options?: grpc_1.CallOptions): grpc_1.ClientDuplexStream<P, R>;
        (options?: grpc_1.CallOptions): grpc_1.ClientDuplexStream<P, R>;
    }
    interface GrpcPromiseServiceInterface<P, R> {
        (message: P, metadata: grpc_1.Metadata, options?: grpc_1.CallOptions): Promise<R>;
        (message: P, options?: grpc_1.CallOptions): Promise<R>;
    }
    export abstract class UnimplementedTenantCliqueService {
        static definition = {
            Query: {
                path: "/api.core.TenantClique/Query",
                requestStream: false,
                responseStream: false,
                requestSerialize: (message: dependency_2.google.protobuf.Empty) => Buffer.from(message.serialize()),
                requestDeserialize: (bytes: Buffer) => dependency_2.google.protobuf.Empty.deserialize(new Uint8Array(bytes)),
                responseSerialize: (message: TenantCliqueQueryResponse) => Buffer.from(message.serialize()),
                responseDeserialize: (bytes: Buffer) => TenantCliqueQueryResponse.deserialize(new Uint8Array(bytes))
            },
            Create: {
                path: "/api.core.TenantClique/Create",
                requestStream: false,
                responseStream: false,
                requestSerialize: (message: TenantCliqueCreateRequest) => Buffer.from(message.serialize()),
                requestDeserialize: (bytes: Buffer) => TenantCliqueCreateRequest.deserialize(new Uint8Array(bytes)),
                responseSerialize: (message: TenantCliqueCreateResponse) => Buffer.from(message.serialize()),
                responseDeserialize: (bytes: Buffer) => TenantCliqueCreateResponse.deserialize(new Uint8Array(bytes))
            },
            Update: {
                path: "/api.core.TenantClique/Update",
                requestStream: false,
                responseStream: false,
                requestSerialize: (message: TenantCliqueUpdateRequest) => Buffer.from(message.serialize()),
                requestDeserialize: (bytes: Buffer) => TenantCliqueUpdateRequest.deserialize(new Uint8Array(bytes)),
                responseSerialize: (message: dependency_2.google.protobuf.Empty) => Buffer.from(message.serialize()),
                responseDeserialize: (bytes: Buffer) => dependency_2.google.protobuf.Empty.deserialize(new Uint8Array(bytes))
            },
            Delete: {
                path: "/api.core.TenantClique/Delete",
                requestStream: false,
                responseStream: false,
                requestSerialize: (message: TenantCliqueDeleteRequest) => Buffer.from(message.serialize()),
                requestDeserialize: (bytes: Buffer) => TenantCliqueDeleteRequest.deserialize(new Uint8Array(bytes)),
                responseSerialize: (message: dependency_2.google.protobuf.Empty) => Buffer.from(message.serialize()),
                responseDeserialize: (bytes: Buffer) => dependency_2.google.protobuf.Empty.deserialize(new Uint8Array(bytes))
            }
        };
        [method: string]: grpc_1.UntypedHandleCall;
        abstract Query(call: grpc_1.ServerUnaryCall<dependency_2.google.protobuf.Empty, TenantCliqueQueryResponse>, callback: grpc_1.sendUnaryData<TenantCliqueQueryResponse>): void;
        abstract Create(call: grpc_1.ServerUnaryCall<TenantCliqueCreateRequest, TenantCliqueCreateResponse>, callback: grpc_1.sendUnaryData<TenantCliqueCreateResponse>): void;
        abstract Update(call: grpc_1.ServerUnaryCall<TenantCliqueUpdateRequest, dependency_2.google.protobuf.Empty>, callback: grpc_1.sendUnaryData<dependency_2.google.protobuf.Empty>): void;
        abstract Delete(call: grpc_1.ServerUnaryCall<TenantCliqueDeleteRequest, dependency_2.google.protobuf.Empty>, callback: grpc_1.sendUnaryData<dependency_2.google.protobuf.Empty>): void;
    }
    export class TenantCliqueClient extends grpc_1.makeGenericClientConstructor(UnimplementedTenantCliqueService.definition, "TenantClique", {}) {
        constructor(address: string, credentials: grpc_1.ChannelCredentials, options?: Partial<grpc_1.ChannelOptions>) {
            super(address, credentials, options);
        }
        Query: GrpcUnaryServiceInterface<dependency_2.google.protobuf.Empty, TenantCliqueQueryResponse> = (message: dependency_2.google.protobuf.Empty, metadata: grpc_1.Metadata | grpc_1.CallOptions | grpc_1.requestCallback<TenantCliqueQueryResponse>, options?: grpc_1.CallOptions | grpc_1.requestCallback<TenantCliqueQueryResponse>, callback?: grpc_1.requestCallback<TenantCliqueQueryResponse>): grpc_1.ClientUnaryCall => {
            return super.Query(message, metadata, options, callback);
        };
        Create: GrpcUnaryServiceInterface<TenantCliqueCreateRequest, TenantCliqueCreateResponse> = (message: TenantCliqueCreateRequest, metadata: grpc_1.Metadata | grpc_1.CallOptions | grpc_1.requestCallback<TenantCliqueCreateResponse>, options?: grpc_1.CallOptions | grpc_1.requestCallback<TenantCliqueCreateResponse>, callback?: grpc_1.requestCallback<TenantCliqueCreateResponse>): grpc_1.ClientUnaryCall => {
            return super.Create(message, metadata, options, callback);
        };
        Update: GrpcUnaryServiceInterface<TenantCliqueUpdateRequest, dependency_2.google.protobuf.Empty> = (message: TenantCliqueUpdateRequest, metadata: grpc_1.Metadata | grpc_1.CallOptions | grpc_1.requestCallback<dependency_2.google.protobuf.Empty>, options?: grpc_1.CallOptions | grpc_1.requestCallback<dependency_2.google.protobuf.Empty>, callback?: grpc_1.requestCallback<dependency_2.google.protobuf.Empty>): grpc_1.ClientUnaryCall => {
            return super.Update(message, metadata, options, callback);
        };
        Delete: GrpcUnaryServiceInterface<TenantCliqueDeleteRequest, dependency_2.google.protobuf.Empty> = (message: TenantCliqueDeleteRequest, metadata: grpc_1.Metadata | grpc_1.CallOptions | grpc_1.requestCallback<dependency_2.google.protobuf.Empty>, options?: grpc_1.CallOptions | grpc_1.requestCallback<dependency_2.google.protobuf.Empty>, callback?: grpc_1.requestCallback<dependency_2.google.protobuf.Empty>): grpc_1.ClientUnaryCall => {
            return super.Delete(message, metadata, options, callback);
        };
    }
}
