module Display
	where

import System.IO
import Data.Char
import QuizData

						 
display :: QuizData -> QuizData -> String
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
			 
			 
displayonething :: QuizData -> String
displayonething x = "<a href=\"ex3.html\"><div class=\"queryobject\"><img src=\"img/" 
				 ++ getPicURL x ++ "\"><p>" ++ getName x ++ "</div></a>\n"
