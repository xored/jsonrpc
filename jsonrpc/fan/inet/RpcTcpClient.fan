using inet
const class RpcTcpClient : AsyncClient
{
  new make(IpAddr addr, Int port) : super(InetTransport(addr, port)) {}
}

const class InetTransport : AsyncTransport
{
  private const IpAddr addr
  private const Int port
  new make(IpAddr addr, Int port)
  {
    this.addr = addr
    this.port = port
  }
  
  override Void send(Str str) {}
  
  override Void setConsumer(|Str| consumer) {}
}