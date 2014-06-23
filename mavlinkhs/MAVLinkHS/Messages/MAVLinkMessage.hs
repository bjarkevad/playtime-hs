module MAVLinkHS.Messages.MAVLinkMessage where
import Data.Binary
--import qualified Data.ByteString.Lazy as BL

class MAVLinkMessage a where
    length :: a -> Word8
    extraCRC :: a -> Word8
