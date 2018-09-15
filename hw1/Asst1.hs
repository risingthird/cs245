{- Name: Jiaping Wang
 File: Asst1.hs
 Desc: CS245, Assignment 1
-}

{-
Using Atom with haskell language plugin;
Nothing weird occurs.
-}

module Asst1 where

doNothing x = x

add1 :: Float -> Float
add1 arg1 = arg1 + 1

always0 :: Integer -> Integer
always0 arg1 = 0

sub :: Integer -> Integer -> Integer
sub m n = m - n

addmult :: Integer -> Integer -> Integer -> Integer
addmult p q r = (p+q)*r

myAbs :: Integer -> Integer
myAbs arg
  | arg > 0   = arg
  | otherwise = -arg

pushOut :: Integer -> Integer
pushOut arg
  | arg > 0   = arg + 1
  | arg < 0   = arg - 1
  | otherwise = 0

greet :: String -> String
greet arg = "Hi " ++ arg

greet2 :: String -> String
greet2 arg
  | (null arg) == True = "Hi there"
  | otherwise  = "Hi " ++ arg

-- problem 13
{-
makeAs 3
=    {apply makeAs}
"a" ++  makeAs (2)
=    {apply makeAs}
"a" ++ ("a" ++ makeAs(1))
=    {apply makeAs}
"a" ++ ("a" ++ ("a" ++ makeAs(0))))
=    {apply makeAs}
"a" ++ ("a" ++ ("a" ++ "")))
"a" ++ ("a" ++ "a")
"a" ++ "aa"
"aaa"
-}


makeAs 0 = ""
makeAs n = "a" ++ makeAs (n-1)

twiceAs 0 = ""
twiceAs n = makeAs n ++ makeAs n

countDown 1 = "1 "
countDown n
  | n < 1     = "Too low"
  | otherwise = show n ++ " " ++ countDown (n-1)

countUp 1 = "1 "
countUp n
  | n < 1     = "Too low"
  | otherwise = countUp (n-1) ++ show n ++ " "

-- Don't know whether this is ok
triangle n
  | n < 1     = error "Invalid Argument"
  | otherwise = sum[1..n]

-- divides :: Integer -> Integer -> Bool
-- divides m n
--   | n `mod` m == 0 = True
--   | otherwise = False

divides m n = n `mod` m == 0

hasNoDivisorsLessThan n 2 = True
hasNoDivisorsLessThan n d
  | d < 1     = False
  | d == 1    = False
  | otherwise = (not ((d-1) `divides` n)) && hasNoDivisorsLessThan n (d-1)

--guess it from the syntax from Python, and it works well
isPrime m
  | m < 1     = False
  | otherwise = hasNoDivisorsLessThan m m
