module MAVLinkHS.Messages.HeartBeat where

import Data.Binary.Put
import Data.Binary.Get
import Data.Binary
import MAVLinkHS.Messages.MAVLinkMessage

data HeartBeat = HeartBeat {
    typet :: Word8,
    autopilot :: Word8,
    basemode :: Word8,
    custommode :: Word32,
    systemstatus :: Word8,
    version :: Word8
}

instance MAVLinkMessage HeartBeat where
    length _ = 9
    crcExtra _ = 50

instance Binary HeartBeat where
    put h = do 
       putWord32be $ custommode h
       putWord8 $ typet h
       putWord8 $ autopilot h
       putWord8 $ basemode h
       putWord8 $ systemstatus h
       putWord8 $ version h
        
    get = do
        cm <- getWord32be
        t <- getWord8
        ap <- getWord8
        bm <- getWord8
        ss <- getWord8
        v <- getWord8
        return $ HeartBeat t ap bm cm ss v


heartBeatLen :: Word8
heartBeatLen = 9

heartBeatCRC :: Word8
heartBeatCRC = 50
