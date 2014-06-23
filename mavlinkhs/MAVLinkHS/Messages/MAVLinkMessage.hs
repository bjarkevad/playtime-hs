module MAVLinkHS.Messages.MAVLinkMessage where
import Data.Binary

class MAVLinkMessage a where
    length :: a -> Word8
    crcExtra :: a -> Word8
