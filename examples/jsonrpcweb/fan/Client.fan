using jsonrpc

class Client
{
  Void main()
  {
    math := RpcWebClient(`http://localhost:8080/math`)
    echo(math.request("sum", [[1,2,3]]))
    file := RpcWebClient(`http://localhost:8080/file`)
    echo(file.request("ls", ["dir" : "/Users/ivaninozemtsev/"]))
  }
}
