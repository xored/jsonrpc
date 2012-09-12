
mixin RpcConsts
{
  static const Version defVersion := Version("2.0")
  static const Str idField := "id"
  static const Str paramsField := "params"
  static const Str methodField := "method"
  static const Str versionField := "jsonrpc"
  static const Str[] requestFields := [idField, paramsField, 
    methodField, versionField]
  
  static const Str resultField := "result"
  static const Str errField := "error"
  static const Str[] errResponseFields := [idField, versionField, errField]
  static const Str[] resultResponseFields := [idField, versionField, resultField]
  
  static const Str codeField := "code"
  static const Str messageField := "message"
  static const Str dataField := "data"
  static const Str[] errFields := [codeField, messageField, dataField]

  static const Int parseErrCode := -32700
  static const Int invalidRequestCode := -32600
  static const Int methodNotFoundCode := -32601
  static const Int invalidParamsCode := -32602
  static const Int internalErrorCode := -32603
  static const Int applicationErrorCode := -32500
  
  static const Int:Str defaultMessages := [
      parseErrCode : "Parse error.",
      invalidRequestCode : "Invalid Request.",
      methodNotFoundCode : "Method not found.",
      invalidParamsCode : "Invalid params.",
      internalErrorCode : "Internal error.",
      applicationErrorCode : "Server error."
    ]

}
