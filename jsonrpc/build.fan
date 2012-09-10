using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "jsonrpc"
    version = Version("2.0")
    summary = ""
    srcDirs = [`test/`, `fan/`]
    depends = ["sys 1.0", "util 1.0"]
  }
}
