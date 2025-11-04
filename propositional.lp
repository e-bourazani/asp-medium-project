example_n(X):-example(X,_).
operator(neg;and;or).
double_operator(and;or).
%generate rules for operators and atoms
{for(ID,T,D)}:-ID=1..size,D=1..size,D>ID,operator(T).
{for(ID,atom,C)}:-ID=1..size,attribute(C).
%
%constraints
%
:-{for(ID,_,_)}!=1,ID=1..size.
:-for(ID,T,D),double_operator(T),D>size-1.
:-for(ID,and,D),for(D,atom,A1),for(D+1,atom,A2),A2<=A1.
:-for(ID,or,D),for(D,atom,A1),for(D+1,atom,A2),A2<=A1.
:-for(ID,and,D),for(D,T1,A1),for(D+1,atom,A2),operator(T1).
:-for(ID,or,D),for(D,T1,A1),for(D+1,atom,A2),operator(T1).
:-for(ID,T,D),double_operator(T),for(D,T1,A1),for(D+
1,neg,A2),double_operator(T1).
:-for(ID,T,D),double_operator(T),for(D,and,A1),for(D+1,or,A2).
:-for(ID1,T1,D1),for(ID2,T2,D2),ID1<ID2,operator(T1),operator(T2),ID1!=ID2,
D1>=D2.
:-for(ID1,T1,D1), for(ID2,T2,D2), ID1 < ID2, double_operator(T1),
operator(T2), D1+1>=D2.
%compute size of atoms as 1
formula_size(ID,1):-for(ID,atom,_).
%negation of atoms as size formula they refers to +1
formula_size(ID,Y):-for(ID,neg,D),formula_size(D,X),Y=X+1,X<size.
%size of or and and as size of formula they refers +1
formula_size(ID,T):-for(ID,or,D),formula_size(D,X1),formula_size(D+1,X2),T=X1
+X2+1,X1<size,X2<size.
formula_size(ID,T):-for(ID,and,D),formula_size(D,X1),formula_size(D+1,X2),T=X1
+X2+1,X1<size,X2<size.
%check that the size of the formula is the possible max
:-#max{X:formula_size(1,X)}!=size.
%we store how atoms classify examples
classifies_pos(ID,X):-for(ID,atom,C),has(X,C),ID<=size.
classifies_neg(ID,X):-for(ID,atom,C),not has (X,C),example_n(X),ID<=size.
%we store how negations classify examples
classifies_pos(ID,X):-for(ID,neg,D),classifies_neg(D,X),ID<=size,D<=size.
classifies_neg(ID,X):-for(ID,neg,D),classifies_pos(D,X),ID<=size,D<=size.
%we store how "or" classifies examples
classifies_pos(ID,X):-for(ID,or,D), classifies_pos(D,X),ID<=size,D<=size.
classifies_pos(ID,X):-for(ID,or,D), classifies_pos(D+1,X),ID<=size,D<=size.
classifies_neg(ID,X):-for(ID,or,D), classifies_neg(D,X), classifies_neg(D+
1,X),ID<=size,D<=size.
%we store how "and" classifies examples
classifies_pos(ID,X):-for(ID,and,D), classifies_pos(D,X),classifies_pos(D+
1,X),ID<=size,D<=size.
classifies_neg(ID,X):-for(ID,and,D), classifies_neg(D,X),ID<=size,D<=size.
classifies_neg(ID,X):-for(ID,and,D), classifies_neg(D+1,X),ID<=size,D<=size.
%we optimize the number of correct answers
#maximize{1,X:classifies_pos(1,X),example(X,pos);1,X:classifies_neg(1,X),examp
le(X,neg)}.
#show for/3.