
import {HelloMessage} from 'example_ts/protos/hello_pb';
// import { Timestamp } from '@com_google_protobuf/google/protobuf/timestamp_pb';


console.log("HelloMessage = ", HelloMessage);


console.log("Default output");

var msg = new HelloMessage();
msg.setGreeting("Hello");

// var now = Math.floor(new Date().getTime() / 1000);
// var ts = new Timestamp();
// ts.setSeconds(now);

// msg.setCreateTime(ts);

console.log("msg = ", msg);