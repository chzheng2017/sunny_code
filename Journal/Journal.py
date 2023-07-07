import datetime

journal_entries = []

def add_journal_entry(entry_text=None):
    today = datetime.datetime.now()
    entry_date = today.strftime("%Y-%m-%d")
    day_of_week = today.strftime("%A")
    entry = f"{entry_date} ({day_of_week}): "
    if entry_text is not None:
        entry += entry_text + "\n"
    else:
        while True:
            line = input("> ")
            if line == "":
                break
            entry += line + "\n"
    journal_entries.append(entry)
    print("Journal entry added successfully!")

def print_journal_entries(start_date, end_date):
    start_date = datetime.datetime.strptime(start_date, "%Y-%m-%d")
    end_date = datetime.datetime.strptime(end_date, "%Y-%m-%d")
    for entry in journal_entries:
        entry_date_str = entry.split()[0]
        entry_date = datetime.datetime.strptime(entry_date_str, "%Y-%m-%d")
        if start_date <= entry_date <= end_date:
            print(entry)

def save_journal_entries(filename):
    with open(filename, "w") as file:
        for entry in journal_entries:
            file.write(entry + "\n")

def load_journal_entries(filename):
    global journal_entries
    journal_entries = []
    with open(filename, "r") as file:
        for line in file:
            journal_entries.append(line.strip())

def main():
    filename = "journal_entries.txt"
    load_journal_entries(filename)

    print("Welcome to the Daily Journal App!")
    while True:
        print("\nMENU:")
        print("1. Add a journal entry")
        print("2. Print journal entries for a date range")
        print("3. Save and exit")

        choice = input("Enter your choice (1-3): ")

        if choice == "1":
            add_journal_entry()
        elif choice == "2":
            start_date = input("Enter the start date (YYYY-MM-DD): ")
            end_date = input("Enter the end date (YYYY-MM-DD): ")
            print_journal_entries(start_date, end_date)
        elif choice == "3":
            save_journal_entries(filename)
            print("Journal entries saved successfully.")
            print("Thank you for using the Daily Journal App!")
            break
        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    main()
