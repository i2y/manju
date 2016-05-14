Nonterminals
  root
  module
  module_opener
  module_closer
  class
  class_opener
  class_closer
  toplevel_stmts
  toplevel_stmt
  class_toplevel_stmts
  class_toplevel_stmt
  module_attr_stmt
  module_stmt
  export_stmt
  export_names
  export_name
  export_all_stmt
  import_stmt
  include_stmt
  module_names
  generic_attr_stmt
  behavior_stmt
  record_def_stmt
  patterns_stmt
  patterns_members
  patterns_member
  %function_stmt
  method_stmt
  class_method_stmt
  args
  args_pattern
  no_paren_args
  body
  stmts
  stmt
  binop_expr
  expr
  paren_expr
  cons_expr
  tuple_expr
  map_expr
  for_expr
  binary_comp
  generators
  generator
  list_generator
  binary_generator
  record_expr
  record_fields
  record_field
  record_field_index
  %ref_attr_expr
  fun_expr
  case_expr
  if_expr
  receive_expr
  prim_expr
  binary
  binary_fields
  binary_field
  binary_value
  binary_size
  binary_types
  binary_type
  name_expr
  new_expr
  get_func_expr
  app_expr
  app_args
  no_paren_app_args
  elems
  elem
  cons_elems
  map_elems
  map_elem
  case_clauses
  case_clause
  delims
  delim
  block_opener
  block_closer
  brace_opener
  brace_closer
  paren_opener
  paren_closer
  brack_opener
  brack_closer
  args_opener
  args_closer
  pattern_list
  pattern
  guards
  guard
  operator
  newlines.

Terminals
  range
  dot
  self_dot
  dot_name_lparen
  dot_name
  sharp
  pipeline
  last_pipeline
  cons
  op_floor_div
  op_pow
  lbrack
  rbrack
  lbrace
  rbrace
  lparen
  rparen
  lambda
  binary_begin
  binary_end
  percent
  comma
  thin_arrow
  fat_arrow
  colon_colon
  colon
  op_plus
  op_minus
  op_times
  op_div
  op_append
  op_leq
  op_geq
  op_eq
  op_neq
  op_lt
  op_gt
  op_bitand
  op_bitor
  op_bitxor
  op_bitsl
  op_bitsr
  op_bnot
  new
  bang
  equals
  semi
  at
  amp
  backslash
  import_keyword
  export_keyword
  include_keyword
  export_all
  module_keyword
  class_keyword
  behavior
  require
  def_keyword
  try_keyword
  except_keyword
  as
  finally_keyword
  raise_keyword
  if_keyword
  else_keyword
  match_keyword
  case_keyword
  receive_keyword
  after_keyword
  record_keyword
  patterns
  for
  in
  from
  op_and
  op_or
  op_xor
  op_not
  int
  float
  atom
  name
  str
  nil
  true
  false
  newline
  indent
  dedent.

Rootsymbol root.

Right 10 equals.
Right 20 op_not op_bnot.
Left 30 op_and op_or op_xor op_bitand op_bitor op_bitxor pipeline last_pipeline.
Nonassoc 40 op_eq op_leq op_geq op_neq op_lt op_gt.
Left 45 range.
Left 50 op_plus op_minus op_append.
Left 60 op_pow op_times op_div op_floor_div percent.
Right 70 bang.
Left 80 dot_name_lparen dot_name dot colon_colon.

root -> toplevel_stmts : [[{export_all, 1}] | '$1'].
root -> class : '$1'.

class -> class_keyword name block_opener class_toplevel_stmts block_closer : [[{export_all, 1}] | '$4'].
class -> class_keyword name block_opener export_stmt delims class_toplevel_stmts block_closer : ['$4' | '$6'].

toplevel_stmts -> toplevel_stmt: reject_pass('$1').
toplevel_stmts -> toplevel_stmt toplevel_stmts : reject_pass('$1') ++ '$2'.

class_toplevel_stmts -> class_toplevel_stmt: reject_pass('$1').
class_toplevel_stmts -> class_toplevel_stmt class_toplevel_stmts : reject_pass('$1') ++ '$2'.

delims -> delim delims.
delims -> delim.

delim -> newline.
delim -> semi.

%comments -> comment.
%comments -> comment comments.

toplevel_stmt -> module_attr_stmt : '$1'.
toplevel_stmt -> method_stmt : '$1'.
toplevel_stmt -> delims : [pass].

class_toplevel_stmt -> module_attr_stmt : '$1'.
class_toplevel_stmt -> method_stmt : '$1'.
class_toplevel_stmt -> delims : [pass].

module_attr_stmt -> export_stmt : '$1'.
module_attr_stmt -> export_all_stmt : '$1'.
module_attr_stmt -> import_stmt : '$1'.
module_attr_stmt -> include_stmt : '$1'.
module_attr_stmt -> behavior_stmt : '$1'.
module_attr_stmt -> record_def_stmt : '$1'.
module_attr_stmt -> patterns_stmt : '$1'.
module_attr_stmt -> generic_attr_stmt : '$1'.

export_stmt -> export_keyword export_names : ['$1', '$2'].

export_all_stmt -> export_all : ['$1'].

import_stmt -> from name import_keyword export_names
             : [{from_import, line_of('$1')}, '$2', '$4'].

behavior_stmt -> behavior name : ['$1', '$2'].

record_def_stmt -> record_keyword name block_closer
                 : [{record_def, line_of('$1')}, '$2', []].
record_def_stmt -> record_keyword name record_fields block_closer
                 : [{record_def, line_of('$1')}, '$2', '$3' ].
record_def_stmt -> record_keyword name newlines record_fields block_closer
                 : [{record_def, line_of('$1')}, '$2', '$4' ].

patterns_stmt -> patterns name block_opener patterns_members block_closer
           : [patterns, '$2', '$4'].

patterns_members -> patterns_member : ['$1'].
patterns_members -> patterns_member comma patterns_members : ['$1' | '$3'].

patterns_member -> binop_expr : '$1'.

generic_attr_stmt -> at name args : [attr, '$2', '$3'].

include_stmt -> include_keyword module_names : [attr, {name, 0, include}, '$2'].

module_names -> name : [{atom, 0, to_atom('$1')}].
module_names -> name comma module_names : [{atom, 0, to_atom('$1')} | '$3'].

export_names -> export_name : ['$1'].
export_names -> export_name comma export_names : ['$1' | '$3'].

export_name -> name op_div int : [fun_name, '$1', '$3'].

method_stmt -> def_keyword name args block_opener body block_closer
               : [func, '$2', '$3', '$5'].
method_stmt -> def_keyword name args guards block_opener body block_closer
               : [func, '$2', '$3', '$4','$6'].
method_stmt -> at name newlines def_keyword name args block_opener body block_closer
               : [decorated_func, [attr, '$2', [to_atom_token('$5')]], [func, '$5', '$6', '$8']].
method_stmt -> at name args newlines def_keyword name args block_opener body block_closer
               : [decorated_func, [attr, '$2', '$3' ++ [to_atom_token('$6')]], [func, '$6', '$7', '$9']].
method_stmt -> at name newlines def_keyword name args guards block_opener body block_closer
               : [decorated_func, [attr, '$2', [to_atom_token('$5')]], [func, '$5', '$6', '$7', '$9']].
method_stmt -> at name args newlines def_keyword name args guards block_opener body block_closer
               : [decorated_func, [attr, '$2', '$3' ++ [to_atom_token('$6')]], [func, '$6', '$7', '$8', '$10']].

args -> paren_opener args_pattern paren_closer : '$2'.
args -> paren_opener paren_closer : [].

no_paren_args -> args_pattern : '$1'.

block_opener -> colon indent : '$2'.
block_opener -> colon indent newlines : '$2'.

block_closer -> dedent : '$1'.

brace_opener -> lbrace newlines : '$1'.
brace_opener -> lbrace : '$1'.

brace_closer -> newlines rbrace : '$2'.
brace_closer -> rbrace : '$1'.

paren_opener -> lparen newlines : '$1'.
paren_opener -> lparen : '$1'.

paren_closer -> newlines rparen : '$2'.
paren_closer -> rparen : '$1'.

brack_opener -> lbrack newlines : '$1'.
brack_opener -> lbrack : '$1'.

brack_closer -> newlines rbrack : '$2'.
brack_closer -> rbrack : '$1'.

newlines -> newline newlines.
newlines -> newline.

args_pattern -> expr : ['$1'].
args_pattern -> expr comma args_pattern : ['$1' | '$3'].

body -> stmts : '$1'.

stmts -> stmt : reject_pass('$1').
stmts -> stmts stmt : '$1' ++ reject_pass('$2').
%stmts -> stmt delims: ['$1'].
%stmts -> stmt delims stmts : ['$1' | '$3'].

stmt -> delims : [pass].

stmt -> binop_expr : '$1'.

binop_expr -> binop_expr op_plus binop_expr : ['$2', '$1', '$3'].
binop_expr -> binop_expr op_minus binop_expr : ['$2', '$1', '$3'].
binop_expr -> binop_expr op_times binop_expr : ['$2', '$1', '$3'].
binop_expr -> binop_expr percent binop_expr : ['$2', '$1', '$3'].
binop_expr -> binop_expr op_div binop_expr : ['$2', '$1', '$3'].
binop_expr -> binop_expr op_floor_div binop_expr : ['$2', '$1', '$3'].
binop_expr -> binop_expr op_append binop_expr : ['$2', '$1', '$3'].
binop_expr -> binop_expr pipeline binop_expr : ['$2', '$1', '$3'].
binop_expr -> binop_expr last_pipeline binop_expr : ['$2', '$1', '$3'].
binop_expr -> binop_expr equals binop_expr : ['$2', '$1', '$3'].
binop_expr -> binop_expr op_geq binop_expr : ['$2', '$1', '$3'].
binop_expr -> binop_expr op_leq binop_expr : ['$2', '$1', '$3'].
binop_expr -> binop_expr op_neq binop_expr : ['$2', '$1', '$3'].
binop_expr -> binop_expr op_lt binop_expr : ['$2', '$1', '$3'].
binop_expr -> binop_expr op_gt binop_expr : ['$2', '$1', '$3'].
binop_expr -> binop_expr op_bitand binop_expr : ['$2', '$1', '$3'].
binop_expr -> binop_expr op_bitor binop_expr : ['$2', '$1', '$3'].
binop_expr -> binop_expr op_bitxor binop_expr : ['$2', '$1', '$3'].
binop_expr -> binop_expr op_bitsl binop_expr : ['$2', '$1', '$3'].
binop_expr -> binop_expr op_bitsr binop_expr : ['$2', '$1', '$3'].
binop_expr -> binop_expr op_pow binop_expr : ['$2', '$1', '$3'].
binop_expr -> binop_expr op_and binop_expr : ['$2', '$1', '$3'].
binop_expr -> binop_expr op_or binop_expr : ['$2', '$1', '$3'].
binop_expr -> binop_expr op_xor binop_expr : ['$2', '$1', '$3'].
binop_expr -> binop_expr op_eq binop_expr : ['$2', '$1', '$3'].
binop_expr -> binop_expr bang binop_expr : ['$2', '$1', '$3'].
binop_expr -> binop_expr colon_colon name : ['$2', '$1', '$3'].
binop_expr -> binop_expr range binop_expr : ['$2', '$1', '$3'].
binop_expr -> self_dot name app_args : [{call_method, line_of('$2')}, [name, {name, line_of('$2'), self}], '$2', '$3'].
binop_expr -> binop_expr dot_name_lparen rparen : [{call_method, line_of('$2')}, '$1', {name, line_of('$2'), value('$2')}, []].
binop_expr -> binop_expr dot_name_lparen no_paren_app_args rparen : [{call_method, line_of('$2')}, '$1', {name, line_of('$2'), value('$2')}, '$3'].
binop_expr -> self_dot name : [ref_attr, '$2'].
binop_expr -> binop_expr dot_name : [get_maps_value, '$1', {name, line_of('$2'), value('$2')}].
binop_expr -> binop_expr dot app_args : [apply, [func_ref, '$1'], '$3'].
binop_expr -> op_not binop_expr : ['$1', '$2'].
binop_expr -> op_bnot binop_expr : ['$1', '$2'].
binop_expr -> expr : '$1'.

expr -> case_expr : '$1'.
expr -> paren_expr : '$1'.
expr -> prim_expr : '$1'.
expr -> name_expr : '$1'.
expr -> new_expr : '$1'.
expr -> cons_expr : '$1'.
expr -> tuple_expr : '$1'.
expr -> map_expr : '$1'.
expr -> for_expr : '$1'.
expr -> binary_comp : '$1'.
expr -> record_expr : '$1'.
expr -> record_field_index : '$1'.
expr -> app_expr : '$1'.
expr -> fun_expr : '$1'.
expr -> get_func_expr : '$1'.
%expr -> ref_attr_expr : '$1'.
expr -> if_expr : '$1'.
expr -> receive_expr : '$1'.

paren_expr -> paren_opener binop_expr paren_closer : '$2'.

prim_expr -> int : '$1'.
prim_expr -> float : '$1'.
prim_expr -> atom : '$1'.
prim_expr -> str : '$1'.
prim_expr -> binary : '$1'.
prim_expr -> nil : '$1'.
prim_expr -> true : '$1'.
prim_expr -> false : '$1'.

binary -> binary_begin binary_end : [{binary, line_of('$1')}].
binary -> binary_begin binary_fields binary_end : [{binary, line_of('$1')}, '$2'].

binary_fields -> binary_field : ['$1'].
binary_fields -> binary_field comma binary_fields : ['$1'|'$3'].

binary_field -> binary_value : [binary_field, '$1'].
binary_field -> binary_value op_div binary_types: [binary_field, '$1', '$3'].
binary_field -> binary_value colon binary_size: [binary_field, '$1', '$3', default].
binary_field -> binary_value colon binary_size op_div binary_types: [binary_field, '$1', '$3', '$5'].

binary_value -> int : '$1'.
binary_value -> float : '$1'.
binary_value -> atom : '$1'.
binary_value -> str : '$1'.
binary_value -> name_expr : '$1'.

binary_size -> int : '$1'.
binary_size -> name_expr : '$1'.
binary_size -> paren_expr : '$1'.

binary_types -> binary_type : ['$1'].
binary_types -> binary_type op_minus binary_types : ['$1'|'$3'].

binary_type -> name : '$1'.

name_expr -> name : [name] ++ ['$1'].

new_expr -> new name app_args : ['$1', '$2', '$3'].

cons_expr -> brack_opener brack_closer : nil.
cons_expr -> brack_opener elem brack_closer : [cons, '$2', nil].
cons_expr -> brack_opener cons_elems brack_closer : '$2'.

cons_elems -> elem comma cons_elems : [cons, '$1', '$3'].
cons_elems -> elem cons elem : [cons, '$1', '$3'].
cons_elems -> elem comma elem : [cons, '$1', [cons, '$3', nil]].

tuple_expr -> paren_opener elems paren_closer : [tuple | '$2'].

elems -> elem : ['$1'].
elems -> elem comma elems : ['$1'|'$3'].

elem -> binop_expr : '$1'.

map_expr -> brace_opener map_elems brace_closer : [map, '$2'].
map_expr -> brace_opener brace_closer : [map, []].

map_elems -> map_elem : ['$1'].
map_elems -> map_elem comma map_elems : ['$1' | '$3'].

map_elem -> elem colon elem : [map_field, '$1', '$3'].
%map_elem -> name fat_arrow elem : [map_field_atom, '$1', '$3'].

for_expr -> brack_opener binop_expr generators brack_closer
          : [{list_comp, line_of('$1')}, '$2', '$3'].
for_expr -> brack_opener binop_expr generators guard brack_closer
          : [{list_comp, line_of('$1')}, '$2', '$3', '$4'].
for_expr -> brack_opener binop_expr generators newlines guard brack_closer
          : [{list_comp, line_of('$1')}, '$2', '$3', '$5'].

binary_comp -> binary_begin binary generators binary_end
             : [{binary_comp, line_of('$1')}, '$2', '$3'].
binary_comp -> binary_begin binary generators guard binary_end
             : [{binary_comp, line_of('$1')}, '$2', '$3', '$4'].
binary_comp -> binary_begin binary generators newlines guard binary_end
             : [{binary_comp, line_of('$1')}, '$2', '$3', '$5'].

generators -> generator : ['$1'].
generators -> generator generators : ['$1' | '$2'].

generator -> list_generator : '$1'.
generator -> binary_generator : '$1'.

list_generator -> for binop_expr in binop_expr
                : [{list_generator, line_of('$1')}, '$2', '$4'].

binary_generator -> for binary op_leq binary
                  : [{binary_generator, line_of('$1')}, '$2', '$4'].

%TODO
record_expr -> percent name paren_opener paren_closer
             : [{record, line_of('$1')}, '$2', []].
record_expr -> percent name paren_opener record_fields paren_closer
             : [{record, line_of('$1')}, '$2', '$4' ].

record_fields -> record_field : ['$1'].
record_fields -> record_field comma record_fields : ['$1' | '$3'].

record_field -> name : [record_field, '$1'].
record_field -> name equals binop_expr : [record_field, '$1', '$3'].

record_field_index -> percent name dot name : [record_field_index, '$2', '$4'].

receive_expr -> receive_keyword block_opener case_clauses block_closer
              : ['$1', '$3'].
receive_expr -> receive_keyword block_opener case_clauses block_closer after_keyword int block_opener body block_closer
              : ['$1', '$3', '$6', '$8'].

case_expr -> match_keyword binop_expr block_opener case_clauses block_closer : ['$1', '$2', '$4'].

case_clauses -> case_clause : ['$1'].
case_clauses -> case_clause case_clauses : ['$1' | '$2'].

%case_clause -> case_keyword pattern_list newlines body block_closer: [case_clause, '$2', '$4'].
%case_clause -> case_keyword pattern_list newlines body block_closer newlines : [case_clause, '$2', '$4'].
%case_clause -> case_keyword pattern_list guards newlines body block_closer: [case_clause, '$2', '$3', '$5'].
%case_clause -> case_keyword pattern_list guards newlines body block_closer newlines : [case_clause, '$2', '$3', '$5'].

%case_clause -> case_keyword pattern_list block_opener body : [case_clause, '$2', '$4'].
case_clause -> case_keyword pattern_list block_opener body block_closer : [case_clause, '$2', '$4'].
%case_clause -> case_keyword pattern_list guards newlines body : [case_clause, '$2', '$3', '$5'].
case_clause -> case_keyword pattern_list guards block_closer body block_closer : [case_clause, '$2', '$3', '$5'].

guards -> guard : ['$1'].
guards -> guard comma elems : ['$1' | '$3'].

guard -> if_keyword binop_expr : '$2'.

pattern_list -> pattern : ['$1'].
pattern_list -> pattern comma pattern_list : ['$1' | '$3'].

pattern -> binop_expr: '$1'.

app_expr -> operator app_args : [apply, '$1', '$2'].
app_expr -> name app_args : [apply, [func_ref, '$1'], '$2'].

operator -> name colon_colon name : [func_ref, '$1', '$3'].
operator -> name colon_colon str : [func_ref, '$1', {name, 1, value('$3')}].
operator -> tuple_expr colon_colon name : [func_ref, '$1', '$3'].
operator -> tuple_expr colon_colon str : [func_ref, '$1', {name, 1, value('$3')}].
operator -> str colon_colon name : [func_ref, '$1', '$3'].
operator -> str colon_colon str : [func_ref, '$1', {name, 1, value('$3')}].

%app_args -> paren_opener elems paren_closer fun_expr: '$2' ++ ['$4'].
app_args -> paren_opener elems paren_closer : '$2'.
%app_args -> paren_opener paren_closer fun_expr : ['$3'].
app_args -> paren_opener paren_closer : [].
%app_args -> fun_expr : ['$1'].

no_paren_app_args -> elems : '$1'.

args_opener -> cons.
args_opener -> cons newlines.
args_opener -> newlines cons.
args_closer -> cons.
args_closer -> cons newlines.
args_closer -> newlines cons.

fun_expr -> lambda no_paren_args colon binop_expr : [func, '$2', ['$4']].
fun_expr -> lambda colon binop_expr : [func, [], ['$3']].
fun_expr -> lambda block_opener body block_closer : [func, [], '$3'].
fun_expr -> lambda no_paren_args block_opener body block_closer : [func, '$2', '$4'].

%TODO elif
if_expr -> if_keyword binop_expr block_opener body block_closer : ['$1', '$2', '$4'].
if_expr -> if_keyword binop_expr block_opener body block_closer else_keyword block_opener body block_closer
         : ['$1', '$2', '$4', '$8'].
if_expr -> if_keyword binop_expr block_opener body block_closer else_keyword if_expr
         : ['$1', '$2', '$4', ['$7']].
%if_expr -> if_keyword binop_expr newlines body else_keyword if_expr
%         : ['$1', '$2', '$4', ['$6']].

get_func_expr -> amp name dot name op_div int : [get_func, '$2', '$4', '$6'].
get_func_expr -> amp name op_div int : [get_func, '$2', '$4'].


Erlang code.

line_of(Token) ->
    element(2, Token).

to_atom(Token) ->
    list_to_atom(element(3, Token)).

to_atom_token(Token) ->
    {atom, line_of(Token), to_atom(Token)}.

value(Token) ->
    element(3, Token).

reject_pass(Expr) ->
    case Expr of
        [pass] -> [];
        _ -> [Expr]
    end.