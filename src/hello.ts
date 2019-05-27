
import { Timestamp } from 'google-protobuf/google/protobuf/timestamp_pb';
import { HelloMessage } from 'example_ts/protos/hello_pb';


var msg = new HelloMessage();
msg.setGreeting("Hello");

var ts = new Timestamp();
ts.fromDate(new Date());

msg.setCreateTime(ts);

console.log("msg = ", msg.toObject());
