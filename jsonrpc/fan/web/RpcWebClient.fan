using web

const class RpcWebClient : SyncClient
{
  new make(Uri endpoint) : super(WebClientTransport(endpoint)) {} 
}

const class WebClientTransport : SyncTransport
{
  private const Uri endpoint
  new make(Uri endpoint) { this.endpoint = endpoint }
  
  override Str? send(Str request) 
  {
    WebClient(endpoint) 
    { 
      reqHeaders["Content-Type"] = "application/json" 
    }.postStr(request).resStr
  }
}