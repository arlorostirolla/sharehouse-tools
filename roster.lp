% Constants
time(kitchen, 30).
time(bathroom, 20).
time(back_area, 40).
time(front_area, 20).
grossness(kitchen, 3).
grossness(bathroom, 5).
grossness(back_area, 1).
grossness(front_area, 1).
regularity(kitchen, 4).
regularity(bathroom, 4).
regularity(back_area, 2).
regularity(front_area, 1).

% Helper rules
person("arlo"; "huw"; "adrian"; "javi"; "tom").
month(M) :- M = 1..12.
chore(C) :- time(C, _).
week(W) :- W = 1..4.

% Assignments
1 { assigned(P, C, M, W) : person(P) } 1 :- month(M), chore(C), regularity(C, R), week(W), R >= W.


% Time constraints
total_time(P, M, T) :- person(P), month(M), T = #sum{ assigned(P, C, M, _) * Time : chore(C), time(C, Time) }.
max_time(P, M) :- person(P), month(M), total_time(P, M, T1), T1 <= T2 + Time, person(P2), month(M2), total_time(P2, M2, T2), time(_, Time).

% Grossness constraints
total_grossness(P, M, G) :- person(P), month(M), G = #sum{ assigned(P, C, M, _) * Gross : chore(C), grossness(C, Gross) }.
max_grossness(P, M) :- person(P), month(M), total_grossness(P, M, G1), G1 <= G2 + Gross, person(P2), month(M2), total_grossness(P2, M2, G2), grossness(_, Gross).

% One chore per week constraint
:- person(P), month(M), week(W), 1 < #count{ C : assigned(P, C, M, W) }.

% Output
#show assigned/4.
