

example_n(X):-example(X,_).
operator(neg;and;or).
double_operator(and;or).

%generate rules for operators and atoms
{for(ID,T,D)}:-ID=1..M,D=1..M,D>ID,operator(T),max_size(M).
{for(ID,atom,C)}:-ID=1..M,attribute(C),max_size(M).

%
%constraints
%

:-formula_size(1,X),T=#count{ID:for(ID,_,_)},X!=T.
:-for(_,T,ID),T!=atom, not for(ID,_,_).
:-for(ID,_,_),not for(ID-1,_,_),ID!=1.

%:-{for(ID,_,_)}!=1,ID=1..size. % it cant be the case that we have no formula

%:-for(ID,T,D),double_operator(T),D>size-1. % it cant be the case that double operators refer to formulas out of bounds
:-for(ID,T,D),double_operator(T),D>M-1,max_size(M).

%:-for(ID,neg,D),D>size. % it cant be the case that neg refers to formulas out of bounds
:-for(ID,T,D),double_operator(T),D>M-1,max_size(M).

:-for(ID,and,D),for(D,atom,A1),for(D+1,atom,A2),A2<=A1.  % it cant be the case that and refers to same atoms in different order
:-for(ID,or,D),for(D,atom,A1),for(D+1,atom,A2),A2<=A1. % it cant be the case that or refers to same atoms in different order
:-for(ID,and,D),for(D,T1,A1),for(D+1,atom,A2),operator(T1). % it cant be the case that and refers to non-atoms
:-for(ID,or,D),for(D,T1,A1),for(D+1,atom,A2),operator(T1). % it cant be the case that or refers to non-atoms
:-for(ID,T,D),double_operator(T),for(D,T1,A1),for(D+1,neg,A2),double_operator(T1). % it cant be the case that double operators refer to negations
:-for(ID,T,D),double_operator(T),for(D,and,A1),for(D+1,or,A2). % it cant be the case that double operators refer to different operators
:-for(ID1,T1,D1),for(ID2,T2,D2),ID1<ID2,operator(T1),operator(T2),ID1!=ID2,D1>=D2. %it cant be the case that operators are not ordered by depth
:-for(ID1,T1,D1), for(ID2,T2,D2), ID1 < ID2, double_operator(T1),operator(T2), D1+1>=D2. % it cant be the case that double operators are not ordered by depth


%compute size of atoms as 1
formula_size(ID,1):-for(ID,atom,_).%size of atoms is 1
%negation of atoms as size formula they refers to +1
formula_size(ID,Y):-for(ID,neg,D),formula_size(D,X),Y=X+1.
%size of or and and as size of formula they refers +1
formula_size(ID,T):-for(ID,or,D),formula_size(D,X1),formula_size(D+1,X2),T=X1+X2+1.
formula_size(ID,T):-for(ID,and,D),formula_size(D,X1),formula_size(D+1,X2),T=X1+X2+1.


%%%%%%%%%%%%%%%%%%
% Updated section%
%%%%%%%%%%%%%%%%%%

%%%%%%
%Size%
%%%%%%

maximum_size(size).
minimum_size(size).

%previous check that the size of the formula is the possible max
%:-#max{X:formula_size(1,X)}!=size. % formula size must be the max

% Create a derivative atom from maximum/minimum_size.
max_size(M):- M = #max{X:maximum_size(X)}.
min_size(M):- M = #max{X:minimum_size(X)}.

:-{for(ID,_,_)}>1,ID=1..W,max_size(W).
:-T<W,min_size(W),T=#count{ID:for(ID,_,_)}.

% Size constraints, logic rules about IDs
:-for(T-1,and,_),T=#count{ID:for(ID,_,_)}.
:-for(T-1,or,_),T=#count{ID:for(ID,_,_)}.
:-for(T,neg,_),T=#count{ID:for(ID,_,_)}.
:-for(_,and,T),T=#count{ID:for(ID,_,_)}.
:-for(_,or,T),T=#count{ID:for(ID,_,_)}.
:-for(_,neg,T),for(T,neg,_).


%%%%%%%
%Error%
%%%%%%%

%Modified so it works for ui.lp
%we optimize the number of correct answers
%#maximize{1,X:classifies_pos(1,X),example(X,pos);1,X:classifies_neg(1,X),example(X,neg)}.

% Confusion matrix of correctness
correct(X):- example(X,pos),classifies_pos(1,X).
correct(X):- example(X,neg),classifies_neg(1,X).
error(X):- example(X, pos), classifies_neg(1,X).
error(X):- example(X, neg), classifies_pos(1,X).

#maximize{1, X: correct(X)}.
total_errors(E):- E = #count{X:error(X)}.

max_error(X) :- maximum_error(X).
min_error(X) :- minimum_error(X).

:- total_errors(X), maximum_error(Y), X>Y.
:- total_errors(X), min_errors(Y), X<Y.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%we store how atoms classify examples
classifies_pos(ID,X):-for(ID,atom,C),has(X,C).
classifies_neg(ID,X):-for(ID,atom,C),not has (X,C),example_n(X). %atom does not have the attribute in example
%we store how negations classify examples
classifies_pos(ID,X):-for(ID,neg,D),classifies_neg(D,X).%negation of a formula that classifies neg is pos
classifies_neg(ID,X):-for(ID,neg,D),classifies_pos(D,X). %negation of a formula that classifies pos is neg
%we store how "or" classifies examples
classifies_pos(ID,X):-for(ID,or,D), classifies_pos(D,X).
classifies_pos(ID,X):-for(ID,or,D), classifies_pos(D+1,X).
classifies_neg(ID,X):-for(ID,or,D), classifies_neg(D,X), classifies_neg(D+1,X).
%we store how "and" classifies examples
classifies_pos(ID,X):-for(ID,and,D), classifies_pos(D,X),classifies_pos(D+1,X).
classifies_neg(ID,X):-for(ID,and,D), classifies_neg(D,X).
classifies_neg(ID,X):-for(ID,and,D), classifies_neg(D+1,X).



%count for attributes
count_a(1..ATT_N) :- ATT_N = #count { 0,A : attribute(A) }.

1 {att_n(N,A) : count_a(N) } 1 :- attribute(A).

:- att_n(N, A0), att_n(N, A1), A0 < A1.
:- att_n(N0, A0), att_n(N1, A1), N0 < N1, A0 > A1.
:- attribute(A), not att_n(_, A).


#show for/3.


