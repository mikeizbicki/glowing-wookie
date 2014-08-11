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

            let mR = lookup "referer" sessionList
            case mR of
                Just r -> return ()
                Nothing -> do
                    mRef <- getReferer
                    case mRef of
                        Just ref -> withSession sess . withTop sess $ setInSession "referer" ref
                        Nothing -> return ()

            sessionList <- with sess $ sessionToList

            --prints all debug info on webpage
            printDebugInfo sessionList

            writeBS footer

        setter = do
            mvalue <- getParam "Question"
            withSession sess . withTop sess $ setInSession ("Question") (convert mvalue)
            sessionList <- with sess $ sessionToList
            let mC = lookup "counter" sessionList
            case mC of
                Just c ->  withSession sess . withTop sess $ setInSession "counter" $ addOne c 
                Nothing -> withSession sess . withTop sess $ setInSession "counter" "1"
            let ref = lookup "referer" sessionList
            --Gets CSRF token from session data
            csrf <- with sess $ csrfToken
            --Writes user data to csv file
            writeData (convertStr mvalue) (show csrf) (show $ fromMaybe "" ref)
            getter

        convert = T.pack . B.unpack . fromMaybe "set-error"
        convertStr = show . B.unpack . fromMaybe ""


--Used to increment visitor counter
addOne :: T.Text -> T.Text
addOne x = T.pack $ show $ convert x + 1 
    where convert y = read $ T.unpack y :: Int


printIPAddr :: Handler App App ()
printIPAddr =  do
            req <- getRequest
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
            writeBS $ fromJust $ getHeader "User-Agent" reqHeader


getUserHeader :: Handler App App String
getUserHeader = do
            req <- getRequest
            return $ show $ fromJust $ getHeader "User-Agent" req


getBrowser :: Handler App App String
getBrowser = do
        req <- getRequest
        return $ show $ uarFamily $ fromJust $ parseUA $ fromJust $ getHeader "User-Agent" req


getOS :: Handler App App String
getOS = do
        req <- getRequest
        return $ show $ osrFamily $ fromJust $ parseOS $ fromJust $ getHeader "User-Agent" req


getURL :: Handler App App String
getURL = do
        req <- getRequest
        return $ show $ fromJust $ getHeader "Referer" req


getReferer :: Handler App App (Maybe T.Text)
getReferer = do
        req <- getRequest
        return $ fmap (T.pack . B.unpack) $ getHeader "Referer" req


printDebugInfo :: [(T.Text,T.Text)] -> Handler App App ()
printDebugInfo sessionList = do
            mapM_ (writeText . snd) sessionList --prints contents of cookie data
            writeText "<br>Date: "
            printTime
            writeText "<br>IP Address: "
            printIPAddr
            writeText "<br>"
            printUserHeader
            writeText "<br>"
            csrf <- with sess $ csrfToken
            writeText csrf
            writeText "<br>Posts: "
            let d = lookup "counter" sessionList
            writeText $ fromMaybe "0" d


writeData :: String -> String -> String -> Handler App App ()
writeData answer csrf ref = do 
            time <- liftIO $ getTime
            ip <- getIPAddr
            ua <- getUserHeader
            os <- getOS
            browser <- getBrowser
            url <- getURL
            liftIO . appendFile "data.csv" $ time ++ "," ++ ip ++ "," ++ csrf ++ "," ++ ref ++ "," ++ ua ++ ","  ++ os ++ "," ++ browser ++ "," ++ url ++ "," ++ answer ++ "\n"

