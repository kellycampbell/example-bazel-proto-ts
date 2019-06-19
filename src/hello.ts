
import { Timestamp } from 'google-protobuf/google/protobuf/timestamp_pb';
// import { Foo } from 'example_ts/test/foo';
import { HelloMessage } from 'example_ts/protos/hello_pb';



var msg = new HelloMessage();
msg.setGreeting("Hello");

var ts = new Timestamp();
ts.fromDate(new Date());

msg.setCreateTime(ts);

console.log("msg = ", msg.toObject());
// console.log("foo = ", new Foo());
console.log("bar");

// new Foo().setBar(123);

// msg.foo = "123";