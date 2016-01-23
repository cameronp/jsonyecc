%% number_lexer.xrl

Definitions.

Whitespace = [\s\t]
Terminator = \n|\r\n|\r
Comma = ,

Bracket = [\[\]]

Digit = [0-9]
NonZeroDigit = [1-9]
NegativeSign = [\-]
Sign = [\+\-]
FractionalPart = \.{Digit}+

IntegerPart = {NegativeSign}?0|{NegativeSign}?{NonZeroDigit}{Digit}*
IntValue = {IntegerPart}
FloatValue = {IntegerPart}{FractionalPart}|{IntegerPart}{ExponentPart}|{IntegerPart}{FractionalPart}{ExponentPart}

Rules.

{Comma} : skip_token.
{Whitespace} : skip_token.
{Terminator} : skip_token.

{Bracket} : {token, {list_to_atom(TokenChars), TokenLine, TokenChars} }.

{IntValue} : {token, {int, TokenLine, list_to_integer(TokenChars)}}.
{FloatValue} : {token, {float, TokenLine, list_to_float(TokenChars)}}.

Erlang code.
