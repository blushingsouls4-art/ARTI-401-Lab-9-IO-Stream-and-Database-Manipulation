:- dynamic letters/1.

start :-
    retractall(letters(_)),
    assertz(letters([a,b,c])),
    write('Hi. This is the Name Game.'), nl,
    write('You will be given a set of English letters in which you will add, delete or move to create your name.'), nl,
    menu.

menu :-
    nl,
    write('Choose from the following:'), nl,
    write('1- Display the current set of letters'), nl,
    write('2- Add a letter'), nl,
    write('3- Add a letter at the top'), nl,
    write('4- Add a letter at the bottom'), nl,
    write('5- Delete a letter'), nl,
    write('6- Delete all letters'), nl,
    write('7- Exit'), nl,
    write('Enter your choice...'), nl,
    read(Choice),
    ( Choice == 7 -> write('Goodbye!'), nl
    ; action(Choice), menu
    ).

action(1) :-
    letters(L),
    write('Current letters: '), write(L), nl.

action(2) :-
    write('Enter a letter: '), read(X),
    write('Enter the position (starting from 1): '), read(Pos),
    letters(L),
    ( integer(Pos), Pos >= 1, length(L,N), Pos =< N+1 ->
        insert_at(X,L,Pos,New), update_letters(New),
        write('Letter added'), nl
    ; write('Invalid position'), nl
    ).

action(3) :-
    write('Enter a letter: '), read(X),
    letters(L), update_letters([X|L]),
    write('Letter added at the top'), nl.

action(4) :-
    write('Enter a letter: '), read(X),
    letters(L), append(L,[X],New), update_letters(New),
    write('Letter added at the bottom'), nl.

action(5) :-
    write('Enter the letter to delete: '), read(X),
    letters(L),
    ( select(X,L,New) -> update_letters(New), write('Letter deleted'), nl
    ; write('Letter not found'), nl
    ).

action(6) :-
    update_letters([]),
    write('All letters deleted'), nl.

action(_) :- write('Invalid choice'), nl.

insert_at(X,L,1,[X|L]).
insert_at(X,[H|T],Pos,[H|Rest]) :-
    Pos > 1,
    Next is Pos-1,
    insert_at(X,T,Next,Rest).

update_letters(New) :-
    retractall(letters(_)),
    assertz(letters(New)).
