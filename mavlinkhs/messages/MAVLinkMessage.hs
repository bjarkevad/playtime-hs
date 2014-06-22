module MAVLinkHS.Messages.MAVLinkMessage where
import Data.Binary

class MAVLinkMessage a where
    length :: a -> Word8
    extraCRC :: a -> Word8
