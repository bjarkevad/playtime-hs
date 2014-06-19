module CRC where
import qualified Data.ByteString.Lazy as BS
import GHC.Word (Word8, Word16)
import Data.Bits

crcCalculate :: BS.ByteString -> Word16
crcCalculate = BS.foldl crcAccumulate initValue
    where
        initValue = 0xFFFF :: Word16
        crcAccumulate :: Word16 -> Word8 -> Word16
        crcAccumulate a w = 
                (a `shiftR` 8) `xor` (second `shiftL` 8) `xor` (second `shiftL` 3) `xor` (second `shiftR` 4)
            where
                first = w `xor` (toWord8 a .&. 0xff) :: Word8
                second = fromIntegral $ first `xor` (first `shiftL` 4) :: Word16
                toWord8 :: Word16 -> Word8
                toWord8 x = fromIntegral x .&. 0xFF
