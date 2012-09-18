using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "jsonrpcinet"
    summary = ""
    srcDirs = [`fan/`]
    depends = ["sys 1.0", "util 1.0", "jsonrpc 1.0", "inet 1.0"]
  }
}
