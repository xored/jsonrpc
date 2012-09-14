
const class DelegatingTransport : SyncTransport
{
  private const Server server
  new make(Server server) { this.server = server }
  
  override Str? send(Str req) { server.handle(req) }
}



abstract class SyncClientTest : RpcBaseTest, RpcUtils
{
  abstract SyncClient client()
  
  Void test1()
  {
    verifyEq(client.request("subtract", [42, 23]), 19)
  }
  
  Void test2()
  {
    verifyEq(client.request("subtract", [23, 42]), -19)
  }
  
  Void test3()
  {
    verifyEq(client.request("subtract", ["subtrahend":23, "minuend":42]), 19)
  }
  
  Void test4()
  {
    verifyEq(client.request("subtract", ["minuend":42, "subtrahend":23]), 19)
  }
  
  Void test5()
  {
    client.notify("update", [1,2,3,4,5])
  }
  
  Void test6()
  {
    client.notify("foobar")
  }
  
  Void test7()
  {
    verifyRpcErr(methodNotFoundCode) |->| { client.request("foobar") }
  }
  
  Void test8()
  {
    verifyRpcErr(invalidParamsCode) |->| { client.request("subtract", ["foo"]) }
  }
  
}

class DelegatingClientTest : SyncClientTest
{
  override SyncClient client := Client.sync(DelegatingTransport(Server(ConstSpecHandler()))) 
}
