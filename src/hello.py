import google.protobuf.timestamp_pb2 as timestamp_pb2
from protos.hello_pb2 import HelloMessage

from datetime import datetime

msg = HelloMessage(greeting = "hello", create_time = timestamp_pb2.Timestamp())
msg.create_time.FromDatetime(datetime.utcnow())
# msg.create_time.GetCurrentTime()

print("Msg = %r" % msg)
