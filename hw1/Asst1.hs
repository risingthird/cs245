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
  | otherwise          = "Hi " ++ arg

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

-- makeAs n will return "a...a" a total of n number of "a"
makeAs 0 = ""
makeAs n = "a" ++ makeAs (n-1)

-- twiceAs n will return "a...a" a total of 2n number of "a"
twiceAs 0 = ""
twiceAs n = makeAs n ++ makeAs n

-- countDown will return "n n-1 n-2 ... 1 "
countDown 1 = "1 "
countDown n
  | n < 1     = "Too low"
  | otherwise = show n ++ " " ++ countDown (n-1)

-- countUp n will return "1 2 3 4 5 ... n "
countUp 1 = "1 "
countUp n
  | n < 1     = "Too low"
  | otherwise = countUp (n-1) ++ show n ++ " "

-- triangle 1 return 1
-- triangle 2 return 1 + 2
-- triangle 3 return 1 + 2 + 3
-- and so on so forth
triangle n
  | n < 1     = error "Invalid Argument"
  | otherwise = sum[1..n]

-- divides m n return true if n can be divided by m
divides m n = n `mod` m == 0

-- hasNoDivisorsLessThan n d will return true if n has any divisor larger than 1
-- and less than d
hasNoDivisorsLessThan n 2 = True
hasNoDivisorsLessThan n d
  | d < 2     = False
  | otherwise = (not ((d-1) `divides` n)) && hasNoDivisorsLessThan n (d-1)

-- Return true if m is a prime
isPrime m
  | m < 1     = False
  | otherwise = hasNoDivisorsLessThan m m
