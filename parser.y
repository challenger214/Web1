%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <malloc.h>
#include "tn.h"
#include "global.h"
int type1;
int type2;
int tflag=0;
%}
%token TEOF TFLOAT TCHAR TCONST TIDENTSI TIDENTSF TIDENTSC TIDENTAI TIDENTAF
%token TIDENTAC TIDENTFI TIDENTFF TIDENTFC TIDENTFV TIDENTPSI TIDENTPSF 
%token TIDENTPSC TIDENTPAI TIDENTPAF TIDENTPAC TCOMMENT TCOMMERR TELSE 
%token TEIF TIF TRETURN TVOID TWHILE TTAP TNUMERR TIDENT TPLUS TSTAR TMOD
%token TEQUAL TLESSE TGREATE TAND TOR TINC TDEC TADDASSIGN TSUBASSIGN 
%token TMULASSIGN TDIVASSIGN TMODASSIGN TINT TMINUS TSLASH TASSIGN 
%token TNOTEQU TNOT TLESS TGREAT TLBRACKET TRBRACKET TLBRACE TRBRACE
%token TLSQBRACK TRSQBRACK TSEMICOLON TSBAR TNEW TNUMBER TRNUMBER TCOMMA 
%token TERROR

%right TASSIGN TADDASSIGN TSUBASSIGN TMULASSIGN TDIVASSIGN TMODASSIGN
%left TPLUS TMINUS TSTAR TSLASH TMOD

%nonassoc LOWER_THAN_ELSE
%nonassoc TELSE

%%
mini_c 			: translation_unit				;
translation_unit 		: external_dcl				
			| translation_unit external_dcl			;
external_dcl 		: function_def				
		  	| declaration				;
function_def 		: function_header compound_st	{type1=3;};
function_header 		: dcl_spec function_name TLBRACKET opt_formal_param TRBRACKET 		;
dcl_spec 			: dcl_specifiers				;
dcl_specifiers 		: dcl_specifier				
		 	| dcl_specifiers dcl_specifier			;
dcl_specifier 		: type_qualifier				
			| type_specifier				;
type_qualifier 		: TCONST					;
type_specifier 		: TINT				{type2=1;}
			| TFLOAT				{type2=2;}
			| TCHAR				{type2=3;}
		 	| TVOID				{type2=4;};
function_name 		: TIDENT				{type1=1,tflag=1;};
opt_formal_param 		: formal_param_list			
		   	|					;
formal_param_list 		: param_dcl				
		    	| formal_param_list TCOMMA param_dcl 	;
param_dcl 		: dcl_spec declarator			;
compound_st 		: TLBRACE opt_dcl_list opt_stat_list TRBRACE 	;
opt_dcl_list 		: declaration_list				
			|					;
declaration_list 		: declaration				
			| declaration_list declaration 			;
declaration 		: dcl_spec init_dcl_list TSEMICOLON		;
init_dcl_list 		: init_declarator				
			| init_dcl_list TCOMMA init_declarator 		;
init_declarator 		: declarator				
		 	| declarator TASSIGN TNUMBER		;
declarator 		: TIDENT					{type1=1,tflag=0;}
	     		| TIDENT TLSQBRACK opt_number TRSQBRACK	{type1=2,tflag=0;};
opt_number 		: TNUMBER				
	     		|					;
opt_stat_list 		: statement_list				
		 	|					;
statement_list 		: statement				
		 	| statement_list statement 			;
statement 		: compound_st				
	   		| expression_st				
	   		| if_st					
	   		| while_st					
	   		| return_st					
	   		;
expression_st 		: opt_expression TSEMICOLON		;
opt_expression 		: expression				
		 	|					;
if_st 			: TIF TLBRACKET expression TRBRACKET statement %prec LOWER_THAN_ELSE	
			| TIF TLBRACKET expression TRBRACKET statement TELSE statement 	;
while_st 			: TWHILE TLBRACKET expression TRBRACKET statement 		;
return_st 			: TRETURN opt_expression TSEMICOLON			;
expression 		: assignment_exp				;
assignment_exp 		: logical_or_exp				
			| unary_exp TASSIGN assignment_exp 		
			| unary_exp TADDASSIGN assignment_exp 	
			| unary_exp TSUBASSIGN assignment_exp 	
			| unary_exp TMULASSIGN assignment_exp 	
			| unary_exp TDIVASSIGN assignment_exp 	
			| unary_exp TMODASSIGN assignment_exp 	
			;
logical_or_exp 		: logical_and_exp				
			| logical_or_exp TOR logical_and_exp 		;
logical_and_exp 		: equality_exp				
		 	| logical_and_exp TAND equality_exp 		;
equality_exp 		: relational_exp				
			| equality_exp TEQUAL relational_exp 		
			| equality_exp TNOTEQU relational_exp 		;
relational_exp 		: additive_exp 				
			| relational_exp TGREAT additive_exp 		
			| relational_exp TLESS additive_exp 		
			| relational_exp TGREATE additive_exp 		
			| relational_exp TLESSE additive_exp 		;
additive_exp 		: multiplicative_exp				
			| additive_exp TPLUS multiplicative_exp 		
			| additive_exp TMINUS multiplicative_exp 	;
multiplicative_exp 		: unary_exp				
		    	| multiplicative_exp TSTAR unary_exp 		
		    	| multiplicative_exp TSLASH unary_exp 		
		    	| multiplicative_exp TMOD unary_exp 		;
unary_exp 		: postfix_exp				
	   		| TMINUS unary_exp			
	   		| TNOT unary_exp				
	   		| TINC unary_exp				
	   		| TDEC unary_exp				;
postfix_exp 		: primary_exp				
	      		| postfix_exp TLSQBRACK expression TRSQBRACK 			
	      		| postfix_exp TLBRACKET opt_actual_param TRBRACKET 		
	      		| postfix_exp TINC				
	      		| postfix_exp TDEC				;
opt_actual_param 		: actual_param				
		  	|					;
actual_param 		: actual_param_list				;
actual_param_list 		: assignment_exp				
		   	| actual_param_list TCOMMA assignment_exp 	;
primary_exp 		: TIDENT					
	     		| TNUMBER				
	     		| TLBRACKET expression TRBRACKET		;
%%