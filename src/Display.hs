module Web
	where

import System.IO
import Data.Char

data QuizObject = QuizObject { url :: String
							 , description :: String
							 } deriving (Show, Read)
						 
display :: QuizObject -> QuizObject -> String
display q1 q2 = "<html>\n\n"
			 ++ "<head>\n"
			 ++ "<LINK REL=StyleSheet HREF=\"css/default.css\" TYPE=\"text/css\" MEDIA=screen>\n"
			 ++ "</head>\n\n"
			 ++ "<body>\n\n"
			 ++ "<h1>Which is better?</h1>\n"
			 ++ "<div class=\"container\">\n"
			 ++ displayonething q1
			 ++ "<div class=\"middle\">or</div>\n"
			 ++ displayonething q2
			 ++ "</div>\n\n"
			 ++ "</body>\n\n"
			 ++ "</html>\n\n"
			 
			 
displayonething :: QuizObject -> String
displayonething x = "<a href=\"ex3.html\"><div class=\"queryobject\"><img src=\"img/" 
				 ++ url x ++ "\"><p>" ++ description x ++ "</div></a>\n"

{-
main = do
--display function

	url <- hGetLine "textDocument.txt"
	description <- hGetLine "textDocument.txt"
	url2 <- hGetLine "textDocument.txt"
	description2 <- hGetLine "textDocument.txt"
	
	
	let str = "<html>"
           ++ "<head>"
	
	"<html>"
	"\n"
	+"<head>"
	"<LINK REL=StyleSheet HREF=\"css/default.css\" TYPE=\"text/css\" MEDIA=screen>"
	"</head>\n"
	"<body>\n"
	"<h1>Which is better?</h1>\n"
	"<div class=\"container\">"
	"<a href=\"exe.html\"><div class=\"queryobject\"><img src=\"img/" ++ Show url ++ "\"><p>" ++ Show description ++ "</div></a>"
	"<div class=\"middle\">or</div>"
	"<a href=\"exe.html\"><div class=\"queryobject\"><img src=\"img/" ++ Show url2 ++  "\"><p>" ++ Show description2 ++ "</div></a>"
	"</div>\n"
	"</body>\n"
	"</html>"


-}

	--create data type object with Read / Show abilities
	
	--disp :: Foo -> Foo -> String
	--disp f1 f2 = "<html><body><b>"++show f1++"</b><i>"++show f2"</i></body>"

	--read in from file
	--disp function creates giant string that is basically the entire webpage
	--USER (not you) then decides what to do with said string
	
	
	

