import qualified Data.ByteString.Lazy as BL
import qualified Data.ByteString.Lazy.Char8 as C
import Data.Binary.Put
import GHC.Word (Word8, Word16, Word32)
import CRC

--main = C.putStrLn serializedHB 
    -- putStrLn $ show $ crcCalculate serializedHB -- $ BS.append serializedHB serializedChk
-- main = putStrLn $ show $ FrameChk (crcCalculate serializedHB)
    --putStr "SerializedHB: "
    --putStr "Checksum: "
    -- print (crcCalculate $ BS.pack [0xfe, 0x09, 0x00, 0x01, 0x02, 0x00, 0x02, 0x00, 0xd0, 0x00, 0x00, 0x00, 0x00, 0x04, 0x7b, 0x1b])
    --print (crcCalculate $ BS.pack [0,1,2,127,255])

main :: IO ()
main = C.putStr $ BL.append serializedHB serializedChk

serializedHB :: BL.ByteString
serializedHB =  runPut (serializeHeader teststart >> serializeHeartBeat testhb) 

serializedChk :: BL.ByteString
serializedChk = runPut (serializeChecksum (crcCalculate serializedHB))

testhb :: HeartBeat
testhb = HeartBeat 2 0 208 0 4 123

teststart :: FrameStart 
teststart = FrameStart 0xFE 9 0 1 200 0

data FrameStart = FrameStart { 
    start :: Word8,
    len :: Word8,
    sequ :: Word8,
    sysid :: Word8,
    compid :: Word8,
    msgid :: Word8
}

type FrameChk = Word16

data HeartBeat = HeartBeat {
    typet :: Word8,
    autopilot :: Word8,
    basemode :: Word8,
    custommode :: Word32,
    systemstatus :: Word8,
    version :: Word8
}

serializeHeader :: FrameStart -> Put 
serializeHeader f = do 
    putWord8 $ start f
    putWord8 $ len f
    putWord8 $ sequ f
    putWord8 $ sysid f
    putWord8 $ compid f
    putWord8 $ msgid f

serializeChecksum :: FrameChk -> Put
serializeChecksum = putWord16be

serializeHeartBeat :: HeartBeat -> Put
serializeHeartBeat h = do
   putWord8 $ typet h 
   putWord8 $ autopilot h 
   putWord8 $ basemode h 
   putWord32be $ custommode h
   putWord8 $ systemstatus h
   putWord8 $ version h
