{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}

module Root
    where
import           Snap
import           Snap.Snaplet.Session
import qualified Data.ByteString.Char8 as B
import qualified Data.Text as T
import           Data.Maybe
import           App
import           Data.Time.Clock (getCurrentTime)
import           Data.Time.Format
import           Web.UAParser

--Handles GET and POST requests on / page
sessionHandler :: B.ByteString -> B.ByteString -> Handler App App ()
sessionHandler header footer = method GET getter <|> method POST setter
    where
        getter = do
            sessionList <- with sess $ sessionToList
            writeBS header
            mapM_ (writeText . snd) sessionList --prints contents of cookie data

            writeText "</br>Date: "
            printTime
            
            --prints number of posts from cookie data
            writeText "</br>Posts: "
            let d = lookup "counter" sessionList
            case d of
                Just d -> writeText d
                Nothing -> withSession sess . withTop sess $ setInSession "counter" "0"

            writeText "</br>IP Address: "
            printIPAddr

            writeText "</br>"
            printUserHeader

            writeText "</br>"
            getBrowser
            writeText "</br>"
            getOS

            writeBS footer
        setter = do
            mvalue <- getParam "Question"
            withSession sess . withTop sess $ setInSession ("Question") (convert mvalue)
            sessionList <- with sess $ sessionToList
            let c = lookup "counter" sessionList
            case c of
                Just c ->  withSession sess . withTop sess $ setInSession "counter" $ addOne c 
                Nothing -> writeText "Error: counter not found"

            writeData  $ convertStr mvalue

            getter
        convert = T.pack . B.unpack . (fromMaybe "set-error")
        convertStr = show . B.unpack . fromJust


--Used to increment visitor counter
addOne :: T.Text -> T.Text
addOne x = T.pack $ show $ convert x + 1 
    where convert y = read $ T.unpack y :: Int


printIPAddr :: Handler App App ()
printIPAddr =  do
            req <- getRequest -- :: Request -> Snap ByteString
            writeBS (rqRemoteAddr req)


getIPAddr :: Handler App App String
getIPAddr = do
        req <- getRequest
        return $ show $ rqRemoteAddr req


printTime :: Handler App App ()
printTime = do 
            utcTime <- liftIO getCurrentTime
            writeText $ T.pack $ formatTime undefined "%F %T" utcTime


getTime :: IO String 
getTime = fmap show getCurrentTime


printUserHeader :: Handler App App ()
printUserHeader =  do
            reqHeader <- getRequest -- :: Request -> Snap ByteString
            writeBS (fromJust (getHeader "User-Agent" reqHeader))


getBrowser :: Handler App App String
getBrowser = do
        req <- getRequest
        return $ show $ uarFamily $ fromJust $ parseUA $ fromJust (getHeader "User-Agent" req)


getOS :: Handler App App String
getOS = do
        req <- getRequest
        return $ show $ osrFamily $ fromJust $ parseOS $ fromJust (getHeader "User-Agent" req)


writeData :: String -> Handler App App ()
writeData answer = do 
            time <- liftIO $ getTime
            ip <- getIPAddr
            os <- getOS
            browser <- getBrowser
            liftIO . appendFile "data.csv" $ time ++ "," ++ ip ++ "," ++ os ++ "," ++ browser ++ "," ++ answer ++ "\n"

