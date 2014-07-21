{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}

module Root
    where
import           Snap
import           Snap.Snaplet.Session
import           Snap.Snaplet.Session.Backends.CookieSession
import qualified Data.ByteString.Char8 as B
import qualified Data.Text as T
import           Data.Maybe
import           Control.Lens.TH
import           App

--Handles GET and POST requests on / page
sessionHandler :: B.ByteString -> B.ByteString -> Handler App App ()
sessionHandler header footer = method GET getter <|> method POST setter
    where
        getter = do
            sessionList <- with sess $ sessionToList
            writeBS header
            mapM_ (writeText . snd) sessionList
            writeText "</br>Posts: "
            let d = lookup "counter" sessionList
            case d of
                Just d -> writeText d
                Nothing -> withSession sess . withTop sess $ setInSession "counter" "0"
            writeBS footer
        setter = do
            mvalue <- getParam "Question"
            withSession sess . withTop sess $ setInSession ("Question") (convert mvalue)
            sessionList <- with sess $ sessionToList
            let c = lookup "counter" sessionList
            case c of
                Just c ->  withSession sess . withTop sess $ setInSession "counter" $ addOne c 
                Nothing -> writeText "Error: counter not found"
            getter
        convert = T.pack . B.unpack . (fromMaybe "set-error")


--Used to increment visitor counter
addOne :: T.Text -> T.Text
addOne x = T.pack $ show $ convert x + 1 
    where convert y = read $ T.unpack y :: Int

