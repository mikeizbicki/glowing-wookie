module QuizData
( BoolM(..)
, QuizData(..)
, parseQuizData
, readit
, readQuiz
, toQuizList
, displayQuizList
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
                          
                          

--functions for parsing strings into QuizData
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
              
--some helper functions for parsing
headwSpace :: [String] -> String
headwSpace xs = map underscoreToSpace $ head xs 

underscoreToSpace :: Char -> Char
underscoreToSpace '_' = ' '
underscoreToSpace c = c
             


--main function for reading in a file and converting to list of QuizData
readit :: String -> IO [QuizData]
readit filename = do
    contents <- readFile filename
    return $ toQuizList $ lines contents

--This function is used to load up quizes
readQuiz :: Int -> Int -> IO [QuizData]
readQuiz x y = readit $ "./src/data/quiz" ++ (show x) ++ "/question" ++ (show y) ++ ".txt"

    
--helper functions for reading in file;
--toQuizList and displayQuizList can also be used by user
toQuizList :: [String] -> [QuizData]
toQuizList xs = unMaybeQuizList $ map parseQuizData xs

displayQuizList :: [QuizData] -> String
displayQuizList [] = ""
displayQuizList (x:xs) = (show x) ++ "<br>" ++ (displayQuizList xs)

unMaybeQuizList :: [Maybe QuizData] -> [QuizData]
unMaybeQuizList xs = let f = (\(Just x) -> x)
                     in map f $ filter (/= Nothing) xs