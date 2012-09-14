using concurrent

const class DelegatingAsync : AsyncTransport
{
  private const Server server
  new make(Server server) { this.server = server }

  private const Unsafe consumerBox := Unsafe([,])
  private |Str| consumer
  {
    get { consumerBox.val->first }
    set 
    {
      val := it
      List list := consumerBox.val
      list.clear
      list.add(val) 
    }
  }
  
  override Void send(Str str) 
  { 
    consumer(server.handle(str))
  }
  
  override Void start(|Str| consumer) { this.consumer = consumer }
  
  override Void stop() {}
}

abstract class AsyncClientTest : RpcBaseTest, RpcUtils
{
  abstract AsyncClient client()
  
  Void test1() { verifyResponseA("subtract", [42, 23], 19) }
  Void test2() { verifyResponseA("subtract", [23, 42], -19) }
  Void test3() { verifyResponseA("subtract", ["subtrahend":23, "minuend":42], 19) }
  Void test4() { verifyResponseA("subtract", ["minuend":42, "subtrahend":23], 19) }
  Void test7() { verifyRpcErrA("foobar", null, methodNotFoundCode) }
  Void test8() { verifyRpcErrA("subtract", null, invalidParamsCode) }
  
  private Void verifyRpcErrA(Str method, Obj? params, Int code) 
  {
    future := MyFuture()
    thisBox := Unsafe(this)
    client.request(method, params) |handle|
    {
      RpcBaseTest test := thisBox.val
      test.verifyRpcErr(code) |->| { handle.call }
      future.done
    }
    
    while(!future.isDone)
    {
      Actor.sleep(1ms)
    }
  }
  private Void verifyResponseA(Str method, Obj? params, Obj? result)
  {
    future := MyFuture()
    resultBox := Unsafe(result)
    thisBox := Unsafe(this)
    client.request(method, params) |handle|
    {
      thisBox.val->verifyEquiv(handle.call, resultBox.val)
      future.done
    }
    while(!future.isDone)
    {
      Actor.sleep(1ms)
    }
  }
}
  
internal const class MyFuture
{
  private const Unsafe isDoneBox := Unsafe([false]) 
  Bool isDone() { isDoneBox.val->first }
  Void done() 
  { 
    List list := isDoneBox.val
    list.clear
    list.add(true)
    }
}
class DelegatingAsyncTest : AsyncClientTest
{
  override AsyncClient client := Client.async(DelegatingAsync(Server(ConstSpecHandler())))
}