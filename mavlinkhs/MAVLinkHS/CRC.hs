module MAVLinkHS.CRC (crcCalculate, crcCalculateExtra) where
import qualified Data.ByteString.Lazy as BS
import GHC.Word (Word8, Word16)
import Data.Bits

crcCalculateExtra :: BS.ByteString -> Word8 -> Word16
crcCalculateExtra bs extra = crcCalculate $ BS.snoc (BS.tail bs) extra

crcCalculate :: BS.ByteString -> Word16
crcCalculate bs = swapBytes $ BS.foldl crcAccumulate initValue bs
    where
        initValue = 0xFFFF :: Word16

crcAccumulate :: Word16 -> Word8 -> Word16
crcAccumulate a w = 
        (a `shiftR` 8) `xor` (second `shiftL` 8) `xor` (second `shiftL` 3) `xor` (second `shiftR` 4)
    where
        first = w `xor` (toWord8 a .&. 0xff) :: Word8
        second = fromIntegral $ first `xor` (first `shiftL` 4) :: Word16

-- Internal
toWord8 :: Word16 -> Word8
toWord8 x = fromIntegral x .&. 0xFF
lowByte :: Word16 -> Word16
lowByte x = x .&. 0xFF
highByte :: Word16 -> Word16
highByte x = x `shiftR` 8

swapBytes :: Word16 -> Word16
swapBytes w = lowByte w `shiftL` 8 .|. highByte w
