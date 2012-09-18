using inet
using concurrent

const class RpcService : Service
{
  internal static const Log log := Log.get("inet")
  private const IpAddr? addr
  private const Int port
  private const Unsafe listenerBox
  
  private const ActorPool listenerPool := ActorPool()
  internal const ActorPool processorPool := ActorPool()
  
  internal const Server server
  
  private TcpListener listener() { listenerBox.val }
  
  new make(Handler handler, Int port, IpAddr? addr := null) 
  {
    this.port = port
    this.addr = addr
    this.listenerBox = Unsafe(TcpListener())
    this.server = Server(handler)
  }

  override Void onStart()
  {
    if(listenerPool.isStopped) throw Err("RpcService is already stopped, use new instance to restart")
    Actor(listenerPool, |->| { listen }).send(null)
  }
  
  override Void onStop()
  {
    try listenerPool.stop; catch(Err e) log.err("RpcService stop listener pool", e)
    try listenerPool.stop; catch(Err e) log.err("RpcService stop processor pool", e)
    try listener.close; catch(Err e) log.err("RpcService stop listener socket", e)
  }
  
  private Void listen()
  {
    bind
    while(isServing) serve
  }
  
  private Bool isServing() { !listenerPool.isStopped && !listener.isClosed }
  private Void serve()
  {
    try
    {
      ClientActor(this).send(Unsafe(listener.accept))
    } catch(Err e)
    {
      if(isServing) log.err("RpcService accept on $port", e)
    }
  }
  
  private Void bind()
  {
    while(true)
    {
      try { listener.bind(addr, port); break }
      catch (Err e) 
      { 
        log.err("RpcService cannot bind to port $port", e)
        Actor.sleep(10sec)
      }
    }
    log.info("RpcService started on port $port")
  }
}

internal const class ClientActor : Actor
{
  private const Server server
  new make(RpcService service) : super(service.processorPool) { this.server = service.server }
  
  override Obj? receive(Obj? msg)
  {
    TcpSocket socket := (msg as Unsafe).val
    socket.options.receiveTimeout = 10sec //took from WispActor
    writer := Writer(socket.out, pool)
    while(true)
    {
      try Executor(server, writer, pool).send(socket.in.readUtf)
      catch(IOErr e) 
      {
        if(e.msg.contains("SocketTimeoutException")) continue
        else break
      }
    }
    return null
  }
}

internal const class Executor : Actor
{
  private const Writer writer
  private const Server server
  new make(Server server, Writer writer, ActorPool pool) : super(pool) 
  { 
    this.writer = writer
    this.server = server
  }
  
  override Obj? receive(Obj? msg)
  {
    str := msg as Str
    if(str != null) writer.send(server.handle(str))
    return null
  }
}
internal const class Writer : Actor
{
  private const Unsafe outBox
  private OutStream out() { outBox.val }
  new make(OutStream out, ActorPool pool) : super(pool) { outBox = Unsafe(out) }
  
  override Obj? receive(Obj? msg)
  {
    str := msg as Str
    if(str != null) out.writeUtf(str).flush
    return null
  }
}
