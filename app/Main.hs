module Main where

import Network.HTTP.Types       (status200)
import Network.Wai              (Request, Response, ResponseReceived, responseLBS)
import Network.Wai.Handler.Warp (run)

-- type Application = Request
--                 -> (Response -> IO ResponseReceived)
--                 -> IO ResponseReceived

app :: Request
    -> (Response -> IO ResponseReceived)
    -> IO ResponseReceived
app _request sendResponse = sendResponse $ responseLBS
    status200
    [("Content-Type", "text/plain")]
    "Hello Warp!"

main :: IO ()
main = run 3000 app