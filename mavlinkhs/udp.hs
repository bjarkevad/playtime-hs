import Network.Socket
import qualified Network.Socket.ByteString.Lazy as SBL
import qualified Data.ByteString.Lazy as BL

import MAVLinkHS.MAVLink
import MAVLinkHS.Messages.HeartBeat

import Control.Concurrent
import Data.Binary.Get



main :: IO ()
main = do
    sock <- udpSocket
    n <- loopSend sock finalizedMessage 30
    print n
    where
        testhb :: HeartBeat
        testhb = HeartBeat 2 0 216 0 4 3 
        teststart :: FrameStart 
        teststart = FrameStart 0xFE heartBeatLen 0 1 200 0
        finalizedMessage :: BL.ByteString
        finalizedMessage = finalizeMessage teststart testhb

loopSend :: Socket -> BL.ByteString -> Int -> IO Int
loopSend sock bs n = 
    if n > 0
        then do SBL.send sock bs
                print $ BL.unpack bs
                threadDelay 1000000
                loopSend sock bs (n - 1)
        else return n


port :: PortNumber
port = 14550

address :: HostAddress
address =   16777343

udpSocket :: IO Socket
udpSocket = do
    s <- socket AF_INET Datagram defaultProtocol
    connect s $ SockAddrInet port address
    return s


