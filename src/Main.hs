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
appInit :: B.ByteString -> B.ByteString -> B.ByteString -> [[QuizData]] -> SnapletInit App App
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
    
    
getQuizes :: (MonadSnap m) => [[QuizData]] -> [(B.ByteString, m ())]
getQuizes xs = getQuizesH 1 xs
    where listOfSizes = map length xs
    
          getQuizesH :: (MonadSnap m) => Int -> [[QuizData]] -> [(B.ByteString, m ())]
          getQuizesH _ [] = []
          getQuizesH x (q:qs) = let intTuples = [ (a,b) | a <- [1..quizSize], b <- [1..quizSize], a /= b ]
                                    quizSize = length q
                                in getOneQuiz x intTuples q ++ getQuizesH (x + 1) qs 
                                
          getOneQuiz :: (MonadSnap m) => Int -> [(Int,Int)] -> [QuizData] -> [(B.ByteString, m ())]
          getOneQuiz _ [] _ = []
          getOneQuiz x (i:intTuples) qs = [(B.pack("quiz" ++ (show x) ++ "/item" ++ (show $ fst i) ++ "/item" ++ (show $ snd i)), mkPage)] ++ getOneQuiz x intTuples qs
              where 
                  mkPage = do
                      r1 <- liftIO $ randomRIO (1,length xs)
                      r2 <- liftIO $ randomRIO (1,listOfSizes !! (r1 - 1) )
                      r3 <- randomNotNumIO r1 r2
                      writeBS $ B.pack $ display r1 r2 r3 (qs !! (fst i - 1),qs !! (snd i - 1))
 
                  randomNotNumIO r1 r2 = do
                      r3 <- liftIO $ randomRIO (1,listOfSizes !! (r1 - 1) )
                      if r2 /= r3 then return r3
                                  else randomNotNumIO r1 r2
