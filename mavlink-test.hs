
--main = C.putStrLn serializedHB 
    -- putStrLn $ show $ crcCalculate serializedHB -- $ BS.append serializedHB serializedChk
-- main = putStrLn $ show $ FrameChk (crcCalculate serializedHB)
    --putStr "SerializedHB: "
    --putStr "Checksum: "
    -- print (crcCalculate $ BS.pack [0xfe, 0x09, 0x00, 0x01, 0x02, 0x00, 0x02, 0x00, 0xd0, 0x00, 0x00, 0x00, 0x00, 0x04, 0x7b, 0x1b])
    --print (crcCalculate $ BS.pack [0,1,2,127,255])

--main :: IO ()
--main = C.putStr $ BL.append serializedHB serializedChk

{-serializedHB :: BL.ByteString
serializedHB =  runPut (serializeHeader teststart >> serializeHeartBeat testhb) 

serializedChk :: BL.ByteString
serializedChk = runPut (serializeChecksum (crcCalculate serializedHB))

testhb :: HeartBeat
testhb = HeartBeat 2 0 208 0 4 3 

teststart :: FrameStart 
teststart = FrameStart 0xFE 9 0 1 200 0-}

import MAVLinkHS.MAVLink
import MAVLinkHS.Messages.HeartBeat
import qualified MAVLinkHS.Messages.MAVLinkMessage as ML
import MAVLinkHS.CRC

import qualified Data.ByteString.Lazy as BL
import Data.Binary.Put
import Data.Binary

import Text.Printf
import qualified Data.ByteString.Lazy.Char8 as C

main :: IO ()
main = do
    putStrLn "Messages checksummed: "
    print $ asHex chkMessage
    putStrLn "Full message: "
    print $ asHex unpacked
    where
        asHex :: String -> [String]
        asHex = map (printf "0x%02x")
        unpacked :: String
        unpacked = C.unpack $ BL.append serializedHB serializedChk 
        chkMessage :: String
        chkMessage = C.unpack $ BL.snoc (BL.tail serializedHB) (ML.extraCRC testhb)


serializedHB :: BL.ByteString
serializedHB =  runPut (put teststart >> put testhb) 

serializedChk :: BL.ByteString
serializedChk = runPut $ put (crcCalculateExtra serializedHB testhb)

testhb :: HeartBeat
testhb = HeartBeat 2 0 216 0 4 3 

teststart :: FrameStart 
teststart = FrameStart 0xFE heartBeatLen 0 1 200 0

