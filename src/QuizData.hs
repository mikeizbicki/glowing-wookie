module QuizData
( QuizData(..)
, Question
, Quiz
, parseQuizData
, readit
, readQuiz
, createQuizes
, toQuizList
, displayQuizList
) where

type Question = (QuizData, QuizData)
type Quiz = [Question]

data QuizData = QuizData { getType :: String
                         , getName :: String
                         , getPicURL :: String
                         , getDescription :: String
                         } deriving (Read, Show, Eq)
                          
                          

--functions for parsing strings into QuizData
parseQuizData :: String -> Maybe QuizData
parseQuizData xs
              | length quiz < 3  = Nothing
              | length quiz == 3 = Just $ QuizData first second end ""
              | otherwise        = Just $ QuizData first second third description
                where quiz   = words xs
                      end    = last $ quiz
                      first  = head $ quiz
                      second = map underscoreToSpace $ head $ tail quiz
                      third  = head $ tail $ tail quiz
                      description = unwords $ tail $ tail $ tail quiz
               

underscoreToSpace :: Char -> Char
underscoreToSpace '_' = ' '
underscoreToSpace c = c
             


--main function for reading in a file and converting to list of QuizData
readit :: String -> IO [QuizData]
readit filename = do
    contents <- readFile filename
    return $ toQuizList $ lines contents

questionTuple :: [QuizData] -> Quiz
questionTuple [] = []
questionTuple (x:y:ys) = (x,y) : questionTuple ys

--This function is used to load up quizes
readQuiz :: Int -> IO [[QuizData]]
readQuiz 4 = return []
readQuiz x = do
    listofQuizData <- readit $ "./src/data/quiz" ++ (show x) ++ ".txt"
    listofQuiz <- readQuiz (x + 1)
    return $ ({-questionTuple-} listofQuizData) : listofQuiz

createQuizes :: IO [[QuizData]]
createQuizes = readQuiz 1 

              
    
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