{- Name: Jiaping Wang
 File: Asst2.hs
 Desc: CS245, Assignment 2
-}
module Asst2 where

--finds a value in an association list, returns the third parameter as default value
findWithDefault :: Eq a => a -> [(a,b)] -> b -> b
findWithDefault a [] b = b
findWithDefault a (x:xs) b
    | fst(x) == a = snd(x)
    | otherwise   = findWithDefault a xs b

--finds a value in an association list, returns Nothing as default value
find :: Eq a => a -> [(a,b)] -> Maybe b
find a [] = Nothing
find a (x:xs)
    | fst(x) == a = Just(snd(x))
    | otherwise   = find a xs

--retrieves an element by index from the list
index :: Integer -> [a] -> Maybe a
index _ []     = Nothing
index 0 (x:xs) = Just x
index a (x:xs)
    | a < 0     = Nothing
    | otherwise = index (a-1) xs

--returns all the tails of the input list, including the input list and empty list
tails :: [a] -> [[a]]
tails []     = [[]]
tails (x:xs) = (x:xs) : tails xs

--returns a list of factors of the first parameter in the range 1-(second parameter)
factorsBelow :: Integer -> Integer -> [Integer]
factorsBelow 0 _ = []
factorsBelow n 1 = [1]
factorsBelow n d
    | n `mod` d == 0 = d : (factorsBelow n (d-1))
    | otherwise      = (factorsBelow n (d-1))

--takes a positive integer and returns a list of its factors
factors :: Integer -> [Integer]
factors n = factorsBelow n n

--returns a list of digits in a number in reverse order
digitsR :: Integer -> [Integer]
digitsR n
  | n < 0     = error "Invalid input"
  | n < 10    = [n]
  | otherwise = (n `mod` 10) : (digitsR (n `div` 10))

--returns s list of digits in a number in non-reverse order
digits :: Integer -> [Integer]
digits n
    | n < 0     = error "Invalid input"
    | n < 10    = [n]
    | otherwise = (digits (n `div` 10)) ++ [n `mod` 10]

--takes a list of digits and returns a number comprised of these digits in  reversed order
undigitsR :: [Integer] -> Integer
undigitsR []     = 0
undigitsR (x:xs) = 10 * (undigitsR xs) + x

--takes a list of digits and returns a number comprised of these digits in non-reversed order
undigits :: [Integer] -> Integer
undigits a = undigitsR(digits(undigitsR(a)))

--inserts a value in its correct place in an input list that is in non-decreasing order
insert :: Ord a => a -> [a] -> [a]
insert x [] = [x]
insert x (y:ys)
    | x < y     = x : y : ys
    | otherwise = y : (insert x ys)

--sorts a list using insertion sort, returns list in non-decreasing order
insertionSort :: Ord a => [a] -> [a]
insertionSort []     = []
insertionSort [x]    = [x]
insertionSort (x:xs) = insert x (insertionSort xs)

-- select :: Ord a => a -> [a] -> (a, [a])
-- select num [] = (num, [])
-- select num (x:xs)
--   | x < num = select x (num:xs)
--   | otherwise = (num, x: snd(select num xs))

remove :: Eq a => a -> [a] -> [a] -> [a]
remove x (y:ys) z
    | x == y    = z ++ ys
    | otherwise = remove x ys (z++[y])

--selects the minimum element from a non-empty list, returning that element and the leftover list
select :: Ord a => a -> [a] -> (a, [a])
select num [] = (num, [])
select num x  = (go num x, remove (go num x) (num:x) [])
  where
    go x [] = x
    go x (y:ys)
      | x < y     = go x ys
      | otherwise = go y ys

--sorts a list using selection sort, returns a list in non-decreasing order
selectionSort :: Ord a => [a] -> [a]
selectionSort []     = []
selectionSort (x:xs) = selected:(selectionSort remain)
  where
    selected = fst (select x xs)
    remain   = snd (select x xs)

--merges 2 non-decreasing lists into one non-decreasing list
merge :: Ord a => [a] -> [a] -> [a]
merge [] bs = bs
merge as [] = as
merge (a:as) (b:bs)
  | a < b     = [a] ++ (merge as (b:bs))
  | otherwise = [b] ++ (merge (a:as) bs)

--splits a list in two, such that the difference in length of the two lists is <=1
split :: [a] -> ([a], [a])
split xs = (first, second)
  where first  = take half xs
        second = drop half xs
        half   = (length xs) `div` 2

--sorts a list using merge sort, returns a list in non-decreasing order
mergeSort :: Ord a => [a] -> [a]
mergeSort xs
  | length xs < 2 = xs
  | otherwise     = merge (mergeSort first) (mergeSort second)
                  where first  = fst(split xs)
                        second = snd(split xs)

--partitions a list into two sublists, one where every element is less than the pivot
--and one where every element is greater than or equal to the pivot
partition :: Ord a => a -> [a] -> ([a], [a])
partition _ [] = ([], [])
partition a (b:bs)
  | a > b     = ([b] ++ fst(partition a bs), snd(partition a bs))
  | otherwise = (fst(partition a bs), [b] ++ snd(partition a bs))

--sorts a list using quick sort, returns a list in non-decreasing order
quickSort :: Ord a => [a] -> [a]
quickSort []     = []
quickSort (x:xs) = (quickSort first) ++ [x] ++ (quickSort second)
  where first  = fst(partition x xs)
        second = snd(partition x xs)
