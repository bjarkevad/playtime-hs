module MAVLinkHS.Enums where
import Data.Tuple (swap)
import Data.Maybe (fromJust)

data MavAutoPilot
    = MAV_AUTOPILOT_GENERIC
    | MAV_AUTOPILOT_PIXHAWK
    deriving (Eq, Ord, Read, Show)

instance Enum MavAutoPilot where
    toEnum = fromJust . flip lookup (map swap enumTable)
    fromEnum = fromJust . flip lookup enumTable

enumTable :: [(MavAutoPilot, Int)]
enumTable = [(MAV_AUTOPILOT_GENERIC, 0), (MAV_AUTOPILOT_PIXHAWK, 1)]
