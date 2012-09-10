using util

mixin TestUtils
{
  static Obj json(Str str)
  {
    JsonInStream(str.in).readJson
  }
}
