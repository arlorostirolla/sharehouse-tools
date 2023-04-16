% Constants
time(kitchen, 30).
time(bathroom, 20).
time(back_area, 40).
time(front_area, 20).
grossness(kitchen, 3).
grossness(bathroom, 5).
grossness(back_area, 1).
grossness(front_area, 1).
regularity(kitchen, 1).
regularity(bathroom, 1).
regularity(back_area, 2).
regularity(front_area, 4).

% Helper rules
person("arlo"; "huw"; "adrian"; "javi"; "tom").
month(M) :- M = 1..12.
chore(C) :- time(C, _).
week(W) :- W = 1..4.

% Assignments
1 { assigned(P, C, M, W) : person(P) } 1 :- month(M), chore(C), week(W), regularity(C, R), allowed_week(W, R).

% Allowed weeks based on regularity
allowed_week(W, 1) :- week(W).
allowed_week(W, 2) :- week(W), W == 2.
allowed_week(W, 4) :- week(W), W == 4.

% Time constraints
total_time(P, M, T) :- person(P), month(M), T = #sum { assigned(P, C, M, _) * Time : chore(C), time(C, Time) }.

% Grossness constraints
total_grossness(P, M, G) :- person(P), month(M), G = #sum { assigned(P, C, M, _) * Gross : chore(C), grossness(C, Gross) }.

% One chore per week constraint
:- person(P), month(M), week(W), 1 < #count{ C : assigned(P, C, M, W) }.

% No same chore two weeks in a row constraint
:- assigned(P, C, M, W1), assigned(P, C, M, W2), week(W1), week(W2), W2 = W1 + 1.

% front area must be done at least once per month
:- month(M), 0 == #count { P, W : assigned(P, front_area, M, W) }.

% bathroom and kitchen must be done at least once per week
:- month(M), week(W), 0 == #count { P : assigned(P, bathroom, M, W) }.
:- month(M), week(W), 0 == #count { P : assigned(P, kitchen, M, W) }.

% a certain chore cannot be done twice in one week
:- chore(C), person(P1), person(P2), month(M), week(W), P1 != P2, assigned(P1, C, M, W), assigned(P2, C, M, W).

% Objective function
time_difference(M, D) :- month(M), D = #max { T - T2 : total_time(_, M, T), total_time(_, M, T2) }.
grossness_difference(M, D) :- month(M), D = #max { G - G2 : total_grossness(_, M, G), total_grossness(_, M, G2) }.

% Minimize the differences in time taken and grossness across all people for each month
#minimize { D : time_difference(_, D) }.
#minimize { D : grossness_difference(_, D) }.

% Output
#show assigned/4.
