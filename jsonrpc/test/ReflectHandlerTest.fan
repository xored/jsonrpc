const class TestHandler : ReflectHandler
{
  Void voidVoid() {}
  static Void voidVoidStatic() {}
  
  Int voidInt() { 1 }
  static Int voidIntStatic() { 1 }
  
  Void intVoid(Int i) {}
  static Void intVoidStatic(Int i) {}
  
  Str intStr(Int i) { i.toStr }
  static Void intStrStatic(Int i) { i.toStr }
}
class ReflectHandlerTest : Test
{
  private static const Str voidVoid := TestHandler#voidVoid.name
  private static const Str voidVoidStatic := TestHandler#voidVoidStatic.name
  private static const Str voidInt := TestHandler#voidInt.name
  private static const Str voidIntStatic := TestHandler#voidIntStatic.name
  private static const Str intVoid := TestHandler#intVoid.name
  private static const Str intVoidStatic := TestHandler#intVoid.name
  private static const Str intStr:= TestHandler#intStr.name
  private static const Str intStrStatic := TestHandler#intStr.name

  static const TestHandler handler := TestHandler()
  
  Void testVoidVoid()
  {
    verifyNull(handler.execute(voidVoid, null))
    verifyNull(handler.execute(voidVoid, [,]))
    verifyNull(handler.execute(voidVoid, [:]))
    verifyNull(handler.execute(voidVoidStatic, null))
    verifyNull(handler.execute(voidVoidStatic, [,]))
    verifyNull(handler.execute(voidVoidStatic, [:]))
  }
  
  Void testVoidInt()
  {
    verifyEq(1, handler.execute(voidInt, null))
    verifyEq(1, handler.execute(voidInt, [,]))
    verifyEq(1, handler.execute(voidInt, [:]))
    verifyEq(1, handler.execute(voidIntStatic, null))
    verifyEq(1, handler.execute(voidIntStatic, [,]))
    verifyEq(1, handler.execute(voidIntStatic, [:]))
  }
  
  Void testIntStr()
  {
    verifyEq("1", handler.execute(intStr, [1]))
    verifyEq("1", handler.execute(intStr, ["i":1]))
    verifyEq("1", handler.execute(intStrStatic, [1]))
    verifyEq("1", handler.execute(intStrStatic, ["i":1]))
  }
  
  Void testIntVoid()
  {
    verifyNull(handler.execute(intVoid, [1]))
    verifyNull(handler.execute(intVoid, ["i":1]))
    verifyNull(handler.execute(intVoidStatic, [1]))
    verifyNull(handler.execute(intVoidStatic, ["i":1]))
  }
}
