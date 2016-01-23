%% json_lexer.xrl

Definitions.

%% Characters to skip
Whitespace = [\s\t]
Terminator = \n|\r\n|\r
Comma = ,


%% Meaningful punctuation
Bracket = [\[\]]
Curly = [\{\}]
Colon = :

%% String
HexDigit            = [0-9A-Fa-f]
EscapedUnicode      = u{HexDigit}{HexDigit}{HexDigit}{HexDigit}
EscapedChar    = ["\\\/bfnrt]
StringChar     = ([^\"{Terminator}]|\\{EscapedUnicode}|\\{EscapedChar})
StringValue         = "{StringChar}*"

%% Integer
Digit = [0-9]
NonZeroDigit = [1-9]
NegativeSign = [\-]
Sign = [\+\-]
IntValue = {NegativeSign}?\0|{NegativeSign}?{NonZeroDigit}{Digit}*


%% Float
IntegerPart = {Sign}?{Digit}+
ExponentIndicator = [Ee]
ExponentPart = {ExponentIndicator}{Sign}?{Digit}+
FractionalPart = \.{Digit}+
ParseableFloatValue = {IntegerPart}{FractionalPart}|{IntegerPart}{FractionalPart}{ExponentPart}

%% Boolean
BooleanValue = true|false

%% Null
NullValue = null

%% Erlang will struggle to parse this.  Need to insert the .0
UnparseableFloatValue = {IntegerPart}{ExponentPart}

Rules.

{Comma} : skip_token.
{Whitespace} : skip_token.
{Terminator} : skip_token.

{Bracket} : {token, {list_to_atom(TokenChars), TokenLine, TokenChars} }.
{Curly} : {token, {list_to_atom(TokenChars), TokenLine, TokenChars} }.
{Colon} : {token, {list_to_atom(TokenChars), TokenLine, TokenChars} }.

{IntValue} : {token, {int, TokenLine, list_to_integer(TokenChars)}}.
{ParseableFloatValue} : {token, {float, TokenLine, list_to_float(TokenChars)}}.
{UnparseableFloatValue} : {token, {raw_float, TokenLine, list_to_binary(TokenChars)}}.
{StringValue} : {token, {string, TokenLine, extract_quoted_string_token(TokenChars)}}.
{BooleanValue} : {token, {boolean, TokenLine, list_to_atom(TokenChars) }}.
{NullValue} : {token, {null, TokenLine, nil}}.

Erlang code.

extract_quoted_string_token(Value) -> list_to_binary(lists:sublist(Value, 2, length(Value) - 2)).
