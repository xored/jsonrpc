using inet
using concurrent

const class RpcTcpClient : AsyncClient
{
  new make(IpAddr addr, Int port) 
    : super(InetTransport(ActorPool(), addr, port)) {}
}

const class InetTransport : AsyncTransport
{
  private const ActorPool pool
  private const IpAddr addr
  private const Int port
  private const Unsafe socketBox 
  private TcpSocket socket() { socketBox.val }

  new make(ActorPool pool, IpAddr addr, Int port)
  {
    this.addr = addr
    this.port = port
    this.socketBox = Unsafe(TcpSocket())
    this.pool = pool
  }

  override Void send(Str str) { socket.out.writeUtf(str).flush }

  override Void start(|Str| consumer)
  {
    socket.connect(addr, port)
    Actor(pool) |Obj o| { loop(o) }.send(consumer)
  }
  
  private Void loop(|Str| consumer)
  {
    consumerActor := Actor(pool) |Str str| { consumer(str) }
    while(!pool.isStopped) consumerActor.send(socket.in.readUtf)
  }
  override Void stop() { pool.stop }
}
