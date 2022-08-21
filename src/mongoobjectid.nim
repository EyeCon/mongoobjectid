import std/[bitops, random, os, sequtils, strformat, strutils, sugar, times]

# From: https://www.mongodb.com/docs/manual/reference/method/ObjectId/
# The 12-byte ObjectId consists of:
# - A 4-byte timestamp, representing the ObjectId's creation, measured in seconds since the Unix epoch.
# - A 5-byte random value generated once per process. This random value is unique to the machine and process.
# - A 3-byte incrementing counter, initialized to a random value.

randomize()

template byteNo(x: untyped, n: Natural): untyped =
  x.bitsliced((n*8)..<((n+1)*8)).byte

proc randomBytes(count: Natural): seq[byte] =
  for i in 1..count:
    result.add rand(0xFF).byte

let
  processRandomBytes = randomBytes(5)
var
  processCounter = rand(0xFFFFFF).uint32

proc createOid*(): seq[byte] =
  let epochTimeComponent = epochTime().uint32
  #echo epochTimeComponent.toHex()
  #echo processRandomBytes.map(a => a.toHex()).join("")
  #echo processCounter.toHex()
  result.add epochTimeComponent.byteNo(3)
  result.add epochTimeComponent.byteNo(2)
  result.add epochTimeComponent.byteNo(1)
  result.add epochTimeComponent.byteNo(0)
  result.add processRandomBytes[0]
  result.add processRandomBytes[1]
  result.add processRandomBytes[2]
  result.add processRandomBytes[3]
  result.add processRandomBytes[4]
  result.add processCounter.byteNo(2)
  result.add processCounter.byteNo(1)
  result.add processCounter.byteNo(0)
  processCounter = (processCounter + 1) mod 0x1000000

proc createOidString*(): string = createOid().map(a => a.toHex()).join("")

#when isMainModule:
#  echo createOidString()
#  echo createOidString()
#  sleep(3000)
#  echo createOidString()
#  echo createOidString()
