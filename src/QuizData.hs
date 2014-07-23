module QuizData
( BoolM(..)
, QuizData(..)
, parseQuizData
, readit
) where

data BoolM = Unlikely | Maybe | Definitely deriving (Read, Show, Eq, Ord)

data QuizData = Soda { getName :: String
                     , getPicURL :: String
                     } 
              | Person { getName :: String
                       , isGood :: BoolM
                       , getPicURL :: String
                       }
              | Airline { getName :: String
                        , getPicURL :: String
                        } 
              | PoltIssue { getName :: String
                          , getPicURL :: String
                          } deriving (Read, Show, Eq)
                     
parseQuizData :: String -> Maybe QuizData
parseQuizData xs
              | xs == []             = Nothing
              | first == "Soda"      = parseSoda endxs
              | first == "Person"    = parsePerson endxs
              | first == "Airline"   = parseAirline endxs
              | first == "PoltIssue" = parsePoltIssue endxs
              | otherwise            = Nothing
                where endxs = tail $ words xs
                      first = head $ words xs
              
              
parseSoda :: [String] -> Maybe QuizData
parseSoda xs
          | length xs /= 2 = Nothing
          | otherwise      = Just $ Soda (headwSpace xs) (last xs)
          
parsePerson :: [String] -> Maybe QuizData
parsePerson xs
            | length xs == 2 = Just $ Person (headwSpace xs) (Maybe) (last xs)
            | length xs == 3 = Just $ Person (headwSpace xs) (f xs)  (last xs)
            | otherwise      = Nothing
              where f = read . head . tail
              
parseAirline :: [String] -> Maybe QuizData
parseAirline xs
             | length xs /= 2 = Nothing
             | otherwise      = Just $ Airline (headwSpace xs) (last xs)
              
parsePoltIssue :: [String] -> Maybe QuizData
parsePoltIssue xs
               | length xs /= 2 = Nothing
               | otherwise      = Just $ PoltIssue (headwSpace xs) (last xs)
              
readit :: String -> IO String
readit filename = do
    contents <- readFile filename
    return $ parseFile $ lines contents
    
parseFile :: [String] -> String
parseFile [] = ""
parseFile (x:xs)
    | parseQuizData x == Nothing = "Not valid quiz data type<br>" ++ (parseFile xs)
    | otherwise                  = (show q) ++ "<br>" ++ (parseFile xs)
      where Just q = parseQuizData x

headwSpace :: [String] -> String
headwSpace xs = map underscoreToSpace $ head xs 

underscoreToSpace :: Char -> Char
underscoreToSpace '_' = ' '
underscoreToSpace c = c
      
{-main :: IO ()
main = do
    quizdata <- readit "quizdata.txt"
    putStr quizdata-}