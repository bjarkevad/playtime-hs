module MAVLinkHS.MAVLink where

import Data.Binary.Put
import Data.Binary.Get
import Data.Binary

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
