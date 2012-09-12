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
