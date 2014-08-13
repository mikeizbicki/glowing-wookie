{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Snap
import           Snap.Snaplet.Session.Backends.CookieSession
import qualified Data.ByteString.Char8 as B
import           Snap.Util.FileServe
import           App
import           Root
import           Display
import           QuizData
import           System.Random
import           Snap.Snaplet.Session
import qualified Data.Text as T
import           Web.UAParser
import           Data.Time.Clock (getCurrentTime)
import           Data.Time.Format
import           Data.Maybe


--Initializes the app to use Session Snaplet
appInit :: B.ByteString -> B.ByteString -> B.ByteString -> [Quiz] -> SnapletInit App App
appInit header footer about quizes = makeSnaplet "myapp" "Sample Page" Nothing $ do
    ss <- nestSnaplet "session" sess $ initCookieSessionManager "session.txt" "_session" (Just 3600)
    addRoutes ( [ ("/", sessionHandler header footer)
                , ("about", writeBS about)
                , ("img", serveDirectory "img")
                , ("css", serveDirectory "css")
                ] ++ getQuizes quizes 
              )
    return $ App ss
    

    
--Main function reads html files and calls session functions
main :: IO ()
main = do
    header <- B.readFile "./src/header.html"
    footer <- B.readFile "./src/footer.html"
    about <- B.readFile "./src/about.html"
    quizes <- createQuizes
    serveSnaplet defaultConfig $ appInit header footer about quizes
    
    
getQuizes :: (MonadSnap m, Handler App App ~ m) => [Quiz] -> [(B.ByteString, m ())]
getQuizes xs = getQuizesH 1 xs

getQuizesH :: (MonadSnap m, Handler App App ~ m) => Int -> [Quiz] -> [(B.ByteString, m ())]
getQuizesH _ [] = []
getQuizesH x (q:qs) = getOneQuiz x 1 q ++ getQuizesH (x + 1) qs

getOneQuiz :: (MonadSnap m, Handler App App ~ m) => Int -> Int -> Quiz -> [(B.ByteString, m ())]
getOneQuiz _ _ [] = []
getOneQuiz x y (q:qs) = [(B.pack("quiz" ++ (show x) ++ "/question" ++ (show y)), method GET mkPage <|> method POST setter)] ++ getOneQuiz x (y + 1) qs
    where 
        mkPage = do
            r1 <- liftIO $ randomRIO (1,3)
            r2 <- liftIO $ randomRIO (1,3)
            writeBS $ B.pack $ display r1 r2 q

            sessionList <- with sess $ sessionToList

            let mR = lookup "referer" sessionList
            case mR of
                Just r -> return ()
                Nothing -> do
                    mRef <- getReferer
                    case mRef of
                        Just ref -> withSession sess . withTop sess $ setInSession "referer" ref
                        Nothing -> return ()

            sessionList <- with sess $ sessionToList
            return ()

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
            mkPage

        convert = T.pack . B.unpack . fromMaybe "set-error"
        convertStr = show . B.unpack . fromMaybe ""
