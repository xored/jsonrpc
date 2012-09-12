abstract const class Client
{
  static SyncClient sync(SyncTransport transport)
  {
    SyncClient(transport)
  }
}

const class SyncClient : Client
{
  new make(SyncTransport transport)
  {
    this.transport = transport
  }
  
  private const SyncTransport transport

  Obj? request(Str method, Obj?[]? params := null)
  {
    null
  }
  
  Void notify(Str method, Obj?[]? params := null)
  {
    
  }
}

const class AsyncClient : Client
{
  private const AsyncTransport transport
  new make(AsyncTransport transport)
  {
    this.transport = transport
  }
  
  Void request(Str method, Obj?[]? params, |->| callback) { }
  Void notify(Str method, Obj?[]? params := null) { }
}

abstract const class AsyncTransport
{
  abstract Void send(Str request)
  abstract Void setConsumer(|Str| consumer)
}

abstract const class SyncTransport
{
  abstract Str? send(Str request)
}