using concurrent
const class AsyncClient : Client
{
  private const AsyncTransport transport
  private const ActorPool pool
  private const Actor requestor
  private const CallbackMap callbackMap
  private const Log log := Log.get("jsonrpc") 

  
  new make(AsyncTransport transport)
  {
    this.pool = ActorPool()
    this.transport = transport
    this.requestor = Actor(pool) |Str str| { this.transport.send(str) }
    this.callbackMap = CallbackMap(pool)
    this.transport.start |s| { onResponse(s) }
  }
  
  private Void onResponse(Str responseStr)
  {
    response := makeResponse(responseStr)
    
    | |->Obj| |? callback := callbackMap.get(response.id)
    if(callback == null) 
    { 
      log.err("No callback provided for id $response.id") 
      return
    }
    
    callback.call( |->Obj| { response is ErrResponse ? throw response->err : response->result })
  }
  Void dispose() { transport.stop }
  
  Void request(Str method, Obj? params, | |->Obj| | callback) 
  {
    id := Duration.nowTicks
    callbackMap.set(id, callback)
    requestor.send(makeRequest(method, params, id))
  }
  
  Void notify(Str method, Obj?[]? params := null) { requestor.send(makeRequest(method, params)) }
}

internal const class CallbackMap : Actor
{
  new make(ActorPool pool) : super(pool) {}

  override Obj? receive(Obj? msg)
  {
    list := (Obj[]) msg
    switch(list.first)
    {
      case "put": map[list[1]] = list[2]
      case "get": return map[list[1]]
    }
    
    return null
  }
  
  Void set(Obj id, | |->Obj?| | callback) { send(["put", id, callback].toImmutable) }
  
  | |->Obj?| |? get(Obj id) { send(["get", id].toImmutable).get }
  
  private static const Str key := CallbackMap#key.qname
  private Obj:| |->Obj?| | map() 
  {
    locals.getOrAdd(key) { [:]  }
  }
}

abstract const class AsyncTransport
{
  abstract Void start(|Str| consumer)
  abstract Void stop()
  abstract Void send(Str request)
}
