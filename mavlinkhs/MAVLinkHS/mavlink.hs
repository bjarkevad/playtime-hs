module MAVLinkHS.MAVLink where

import Data.Binary.Put
import Data.Binary.Get
import Data.Binary
import MAVLinkHS.Messages.MAVLinkMessage 
import MAVLinkHS.CRC
import qualified Data.ByteString.Lazy as BL

data FrameStart = FrameStart { 
    start :: Word8,
    len :: Word8,
    sequ :: Word8,
    sysid :: Word8,
    compid :: Word8,
    msgid :: Word8
}

data FrameChk = FrameChk Word16

instance Binary FrameStart where
    put f = do
        putWord8 $ start f
        putWord8 $ len f
        putWord8 $ sequ f
        putWord8 $ sysid f
        putWord8 $ compid f
        putWord8 $ msgid f

    get = undefined 

instance Binary FrameChk where
    put (FrameChk w) = 
        putWord16be w

    get = do 
        w <- getWord16be
        return (FrameChk w)


-- |Combines a frame with a message and calculates and appends its calculated CRC value
finalizeMessage :: MAVLinkMessage m => Binary m => FrameStart -> m -> BL.ByteString
finalizeMessage f m = BL.append message $ checksum message
    where 
        message :: BL.ByteString
        message = runPut $ put f >> put m
        checksum :: BL.ByteString -> BL.ByteString
        checksum bs = runPut $ put $ crcCalculateExtra bs (crcExtra m)
