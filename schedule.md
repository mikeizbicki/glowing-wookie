# Schedule for the summer

**Week 1 (Jun 30)**

learn you a haskell, chapters 5-9

*Wednesday*: Try writing your own version of the following functions: `elem`, `words`, `zip`, `map`, `filter`, `foldr`.  You can find more info about these functions by searching on "hoogle": http://www.haskell.org/hoogle/?hoogle=elem.  If multiple functions of the same name are listed, you want the function in the Prelude module.

**Week 2 (July 7)**

learn you a haskell, chapters 10-13 (14 not necessary)

*Monday*:  Write a program that reads a file containing the information for many circles and rectangles, calculates their area, and returns the total.  Each line of the file will be one shape.  The line will be either:

```
Circle center radius
```

or

```
Rectangle top bottom left right
```

The point of this exercies is to get used to writing and testing pure functions, then linking them with the smallest amount of IO glue possible.  Create data types for `Circle` and `Rectangle`, create functions `parseCircle :: String -> Maybe Circle`, `parseRectangle :: String -> Maybe Rectangle`, `areaCircle :: Circle -> Double`, `areaRectangle :: Rectangle -> Double`.

**Week 3 (July 14)**

We'll be using the snap framework to build the webpage.  Run through [this tutorial](http://snapframework.com/docs/quickstart) and [this tutorial](http://snapframework.com/docs/tutorials/snap-api) to get started.

After following the tutorial, create a simple webpage.  You should have two routes on the page.  The first is `/about` which has just some dummy text.  The second is `/`.  This is the route that we're we'll eventually have the quiz.  For now, pick one of the following tasks for `/`:

1. **sessions** We need to keep track of which people have answered which questions in order to present each user a new question.  We will use sessions to do this.  In snap, this functionality is provided by a [snaplet](http://snapframework.com/snaplets) called snaplet-sessions.  Track sessions for multiple users using the site at the same time, and print their session id's to the webpage.  (Jacob,Dat)

2. **user information** We'll want to track EVERYTHING about the users.  For example, their IP address, what browser they're using, what operating system, and the time and date they access the page.  You'll have to figure out how to access this information from the snap api.  Print it out to the webpage.  (Richard,Michelle)


3. **reading/writing quizes**:  Create a set of data types that you think captures all the information we need to create a quiz.  Generate `Read` and `Show` instances for these types.  Create a few small examples on the hard drive.  Then have the `/` route pick one and display the information to the webpage.

This reading is good if you have time, but not necessary: [real world haskell](http://book.realworldhaskell.org/read/), chapters 8-11

**Week 4 (July 21)**

begin webpage development

**Week 5 (July 28)**

get working prototype

**Week 6 (Aug 4)**

add gamification features

**Week 7 (Aug 11)**

begin blog posts

**Week 8 (Aug 18)**

practice webpage launch, debugging

**Week 9 (Aug 25)**

full launch webpage

## What you'll get paid for

Every blog post you write will get you $50.  If the blog post gets 1000 readers, you'll get an extra $50.  If 5000 readers, another extra $50.  If 15000 readers, another extra $50.

Blog posts should be between 500-2000 words.  They'll be on some coding topic you found interesting while working on this project.  Good ideas are comparisons between C++ and Haskell.

For example:

1.  Compare the error messages between C++ and Haskell.   Which one is easier to figure out?
2.  Compare two libraries that do similar features between C++ and Haskell.
3.  Which language makes it easier to download and install new libraries?
4.  What are your favorite features of Haskell you wish were available in C++ (and vice versa).
5.  Was working on a project an effective way to learn a new language?
6.  Implement a data structure in both C++ and Haskell and see which one is better?
