
{- Name: Rosie Wang, Jiaping Wang, Nanda Bhushan
        File: Lexer.hs
        Desc: Asst3 Style
     -}
module Main where
import Data.Char
import System.Environment
import System.Exit
import System.FilePath
import Data.List -- I found some functions pretty useful here

main :: IO ()
main = do
  args     <- getArgs
  filename <- checkArgs args
  input    <- readFile filename
  let result = lexJava input
  writeFile (takeBaseName filename <.> "lex") (unlines result)

 -- Check the command-line arguments. Returns the filename
 -- to lex upon success.
checkArgs :: [String] -> IO FilePath
checkArgs [path] = pure path

checkArgs _other = do
  putStrLn "Usage: ./Lexer <filename>.java"
  putStrLn "Writes to <filename>.lex"
  exitFailure

-- Takes Java code as input and returns a list of Strings.
-- Each String in the output list is one Java token.
-- Comments and whitespace are discarded.
lexJava :: String -> [String]
lexJava str = lexNoPrefix (findToken str)   -- You will edit this line

lex1 :: Char -> String -> (String, String)
lex1 c "" = ([c], "")
lex1 c (x:xs)
  | isLetter c || c == '_' || c == '$' = lexIdentifier [c] (x:xs)
  | c == '=' || c == '+' || c == '>' || c == '-' || c == '<' ||c == '*' || c == '/'
    || c == '~' || c == '!' || c == '^' || c == '&'|| c == '?' ||c == ':' || c == '%' ||
    c == '(' || c == ')' || c == '{' || c == '}' || c == '[' || c == ']' || c == ';' ||
    c == '.' || c == '@' || c == ',' || c == '|'
    = lexOSeperator [c] (x:xs)  --lex operator and separator
  | isDigit c = lexNum [c] (x:xs)
  | c == '\'' = lexChar [c] (x:xs)
  | c == '"'  = lexString [c] (x:xs)
  | otherwise = error "Something is wrong here"

-- take a string and return a string literal we have checked and the rest of the input
lexString :: String -> String -> (String, String)
lexString c [] = error "Unterminated String ^ ^"
lexString c (x:xs)
  | x /= '"' || (x == '"' && "\\" `isSuffixOf` c) = lexString (c ++ [x]) xs
  | otherwise                                     = (c ++ [x], xs)

-- -- take a string and return a char literal we have checked and the rest of the input
lexChar :: String -> String -> (String, String)
lexChar c [] = error "Unterminated Char"
lexChar c (x:y:z:p:q:xs)
  | x == '\\' && isOctDigit y && isOctDigit z && isOctDigit p && q == '\''
      = (c ++ [x,y,z,p,q], xs)
  | x == '\\' && isOctDigit y && isOctDigit z && p == '\'' = (c ++ [x,y,z,p], xs)
  | x == '\\' && (isOctDigit y || y == '\'' || y == 'n' || y == 'f' || y == 't'||
      y == 'b' || y == '\\') && z == '\'' = (c ++[x,y,z],xs)
  | y == '\'' && x /= '\'' && x /= '\n' && x /= '\r' = (c ++[x,y],xs)
  | otherwise = error "Errorous input1"
lexChar c (x:y:z:p:xs)
  | x == '\\' && isOctDigit y && isOctDigit z && p == '\'' = (c ++ [x,y,z,p], xs)
  | x == '\\' && (isOctDigit y || y == '\'' || y == 'n' || y == 'f' || y == 't'||
      y == 'b' || y == '\\') && z == '\'' = (c ++[x,y,z],xs)
  | y == '\'' && x /= '\'' && x /= '\n' && x /= '\r' = (c ++[x,y],xs)
  | otherwise = error "Errorous input2"
lexChar c (x:y:z:xs)
  | x == '\\' && (isOctDigit y || y == '\'' || y == 'n' || y == 'f' || y == 't'||
      y == 'b'|| y == '\\') && z == '\'' = (c ++[x,y,z],xs)
  | y == '\'' && x /= '\'' && x /= '\n' && x /= '\r' = (c ++[x,y],xs)
  | otherwise = error "Errorous input3"
lexChar c (x:y:xs)
  | y == '\'' && x /= '\'' && x /= '\n' && x /= '\r' = (c ++[x,y],xs) --excluding LF and CR
  | otherwise = error "Errorous input4"

-- lex a numeral literal
lexNum :: String -> String -> (String, String)
lexNum c [] = (c,[])
lexNum [c] (x:xs) -- c must be a digit here
  | c == '0' && (x == 'b' || x == 'B') = lexBinary [c,x] xs
  | c == '0' && (x == 'x' || x == 'X') = lexHex [c,x] xs
  | c == '0' = checkLong (stripUS (lexOct [c] (x:xs))) --DecimalNumeral 0 is checked here
  | isDigit x || x == '_' = checkLong (stripUS (lexDecimal [c] (x:xs)))
  | otherwise  = ([c], (x:xs))
    where
      checkLong (str1, str2)
        | "l" `isPrefixOf` str2 = (str1 ++ "l", drop 1 str2)
        | "L" `isPrefixOf` str2 = (str1 ++ "L", drop 1 str2)
        | otherwise             = (str1, str2)

      stripUS (str1, str2) --strip underscores in the end of number
        | "_" `isSuffixOf` str1 = stripUS (take (length str1 - 1) str1, "_"++ str2 )
        | otherwise             = (str1,str2)

      lexBinary :: String -> String -> (String, String)
      lexBinary c str --Initially, c == "0b" or "0B"
        | hasBi str = checkLong (stripUS (lexBinary1 c str))
        | otherwise = ("0", drop 1 c ++ str)
          where
            hasBi [] = False
            hasBi (x:xs)
              | x == '0' || x == '1' = True
              | x == '_' = hasBi xs
              | otherwise = False

            lexBinary1 :: String -> String -> (String, String)
            lexBinary1 c [] = (c,[]) --Initially, c == "0b" or "0B"
            lexBinary1 c (x:xs)
              | qx == '0' || x == '1' || x == '_' = lexBinary1 (c ++ [x]) xs
              | otherwise = (c, (x:xs))

      lexHex :: String -> String -> (String, String)
      lexHex c str --Initially, c == "0x" or "0X"
        | hasHex str = checkLong (stripUS (lexHex1 c str))
        | otherwise = ("0", drop 1 c ++ str)
          where
            hasHex [] = False
            hasHex (x:xs)
              | isHexDigit x = True
              | x == '_' = hasHex xs
              | otherwise = False

            lexHex1 :: String -> String -> (String, String)
            lexHex1 c [] = (c,[]) --Initially, c == "0x" or "0X"
            lexHex1 c (x:xs)
              | isHexDigit x || x == '_' = lexHex1 (c ++ [x]) xs
              | otherwise = (c, (x:xs))

      lexOct :: String -> String -> (String, String)
      lexOct c [] = (c,[])
      lexOct c (x:xs)
        | (isDigit x && (digitToInt x) < 8) || x == '_' = lexOct (c ++ [x]) xs
        | otherwise  = (c, (x:xs))

      lexDecimal :: String -> String -> (String, String)
      lexDecimal c [] = (c,[])
      lexDecimal c (x:xs)
        | isDigit x || x == '_' = lexDecimal (c ++ [x]) xs
        | otherwise  = (c, (x:xs))

-- lex an identifier
lexIdentifier :: String -> String -> (String, String)
lexIdentifier c [] = (c, [])
lexIdentifier c (x:xs) --c must be a letter
  | isLetterOrDigit x = lexIdentifier (c ++ [x]) xs
  | otherwise = (c, (x:xs))
    where
      isLetterOrDigit a
        | isLetter a || isDigit a || a == '_' || a == '$' = True
        | otherwise = False

lexOSeperator :: String -> String -> (String, String) -- lex Operators and Separators
lexOSeperator x [] = (x,[])
lexOSeperator x (n:ns)
  | x == ['>'] && ">>=" `isPrefixOf` (n:ns) = ((x ++ take 3 (n:ns)), (drop 3 (n:ns)))
  | (x == ['<'] && "<=" `isPrefixOf` (n:ns)) || (x == ['>'] && ">=" `isPrefixOf` (n:ns))||
    (x == ['>'] && ">>" `isPrefixOf` (n:ns)) || (x == ['.'] && ".." `isPrefixOf` (n:ns))
    = ((x ++ take 2 (n:ns)), drop 2 (n:ns))
  | (x == ['&'] && n == '&') || (x == ['|'] && n == '|') || (x == ['+'] && n == '+') ||
    (x == ['-'] && n == '-') || (x == ['<'] && n == '<') || (x == ['>'] && n == '>') ||
    (x == ['-'] && n == '>') || (x == [':'] && n == ':') =  ((x ++ [n]), ns)
  | (x == ['='] || x == ['+'] || x == ['>'] || x == ['-'] || x == ['<'] || x == ['*'] || x == ['!'] ||
    x == ['/'] || x == ['&'] || x == ['|'] || x == ['^'] || x == ['%'] ) && n == '='
    = ((x ++ [n]), ns)
  | otherwise = (x, (n:ns))

-- Discard a prefix of the input string containing only whitespace, 
-- and return a suffix of the input string that starts with a non-discardable character. 
findToken :: String -> String
findToken [] = []
findToken (x:y:xs)
  | x == '/' && y == '*' = findToken (cutComment1 xs) --cut multiline comments
  | x == '/' && y == '/' = findToken (cutComment2 xs) --cut singleline comments
  | isSpace x = findToken (y:xs)
    where
      cutComment1 :: String -> String --excluding everything before "*/"
      cutComment1 [] = []
      cutComment1 (a:b:as)
        | a == '*' && b == '/' = as
        | otherwise = cutComment1 (b:as)
      cutComment1 (x:xs) = (x:xs) --there is only one element

      cutComment2 :: String -> String --excluding everything before "\n"
      cutComment2 [] = []
      cutComment2 (x:xs)
        | x == '\n' = xs
        | otherwise = cutComment2 xs

findToken (x:xs) --there is only one element
  | isSpace x = xs
  | otherwise = (x:xs)

-- Uses lex1 to lex the first token and then recurs to lexJava to lex the rest.
lexNoPrefix :: String -> [String]
lexNoPrefix [] = []
lexNoPrefix (x:xs) = ((fst (lex1 x xs)): lexJava (snd (lex1 x xs)))
