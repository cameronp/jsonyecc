Nonterminals
document
object
members
pair
array
value
elements
number.

Terminals
int float raw_float '[' ']' string boolean null
'{' '}' ':'.

Rootsymbol document.

document -> array : '$1'.
document -> object : '$1'.

object -> '{' '}' : {object, []}.
object -> '{' members '}' : {object, '$2'}.

members -> pair : ['$1'].
members -> pair members : ['$1'] ++ '$2'.

pair -> string ':' value : {unwrap('$1'), '$3'}.

array -> '[' ']' : [].
array -> '[' elements ']' : '$2'.

elements -> value : ['$1'].
elements -> value elements : ['$1'] ++ '$2'.

number -> int : unwrap('$1').
number -> float : unwrap('$1').
number -> raw_float : {raw_float, unwrap('$1')}.

value -> number : '$1'.
value -> array : '$1'.
value -> object : '$1'.
value -> string : {string, unwrap('$1')}.
value -> boolean : unwrap('$1').
value -> null : unwrap('$1').

Erlang code.

unwrap({_,_,V}) -> V.
