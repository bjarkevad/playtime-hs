import MAVLinkHS.MAVLink
import MAVLinkHS.CRC

import qualified Data.ByteString.Lazy as BL
import Data.Binary.Put
--import qualified Data.ByteString.Lazy.Char8 as C

main :: IO ()
main = undefined

serializedHB :: BL.ByteString
serializedHB =  runPut (serializeHeader teststart >> serializeHeartBeat testhb) 

serializedChk :: BL.ByteString
serializedChk = runPut (serializeChecksum (crcCalculate serializedHB))

testhb :: HeartBeat
testhb = HeartBeat 2 0 208 0 4 3 

teststart :: FrameStart 
teststart = FrameStart 0xFE 9 0 1 200 0

