import clingo
import csv

def main():
    # Load the clingo control and add the chores program
    ctl = clingo.Control()
    ctl.load("roster.lp")

    # Ground the program
    ctl.ground([("base", [])])

    # Run the solver and store the answer sets
    rosters = []
    with ctl.solve(yield_=True) as handle:
        for model in handle:
            rosters.append(model.symbols(shown=True))

    # Save the roster as a CSV file
    with open("yearly_roster.csv", "w", newline="") as csvfile:
        roster_writer = csv.writer(csvfile, delimiter=",", quotechar='"', quoting=csv.QUOTE_MINIMAL)
        roster_writer.writerow(["Person", "Chore", "Month", "Week"])

        for roster in rosters:
            for atom in roster:
                person, chore, month, week = atom.arguments
                roster_writer.writerow([str(person), str(chore), str(month), str(week)])

if __name__ == "__main__":
    main()
