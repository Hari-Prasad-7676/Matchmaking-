import csv

credentials_file = r"D:\!Hari prasad.k 12A\Cs class 12 pjkt\Matrimony\credintials.csv"
user_details_file = r"D:\!Hari prasad.k 12A\Cs class 12 pjkt\Matrimony\details.csv"

def flames_game(name1, name2):
    combined = name1 + name2
    unique_letters = []
    for letter in combined:
        if letter not in unique_letters:
            unique_letters.append(letter)
    flames_count = len(unique_letters) % 5
    
    flames_result = ["Friendship", "Love", "Admirer", "Marriage", "Enemy"]
    return flames_result[flames_count - 1]

def signup():
    print("\n--- SIGN UP ---")
    while 1:
        username = input("Enter a unique username: ")
        password = input("Create a strong password: ")

        user_exists = 0
        with open(credentials_file, 'r', newline='') as csvfile:
            reader = csv.reader(csvfile)
            for row in reader:
                if row[0] == username:
                    user_exists = 1
                    break
        
        if user_exists == 1:
            print("⚠️ Username already exists! Please choose a unique username.")
        else:

            with open(credentials_file, 'a', newline='') as csvfile:
                writer = csv.writer(csvfile)
                writer.writerow([username, password])

            gender = input("Enter your gender (M/F): ")
            age = input("Enter your age: ")
            interests = input("Enter your interests (comma-separated): ")

            with open(user_details_file, 'a', newline='') as csvfile:
                writer = csv.writer(csvfile)
                writer.writerow([username, gender, age, interests])

            print("✅ Signup successful! You can now login to start finding a match.\n")
            break

def update_details(username):
    print(f"\n--- UPDATING DETAILS FOR {username} ---")
    rows = []

    with open(user_details_file, 'r', newline='') as csvfile:
        reader = csv.reader(csvfile)

        for row in reader:
            if row[0] == username:
                print("User found. Proceeding with update...")
                gender = input("Enter new gender (M/F): ")
                age = input("Enter new age: ")
                interests = input("Enter new interests (comma-separated): ")
                rows.append([username, gender, age, interests])
            else:
                rows.append(row)

    with open(user_details_file, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerows(rows)
    print("✅ Details updated successfully.\n")

def login():
    print("\n--- LOGIN ---")
    username = input("Enter username: ")
    password = input("Enter password: ")

    user_exists = 0
    with open(credentials_file, 'r', newline='') as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            if row[0] == username and row[1] == password:
                user_exists = 1
                break

    if user_exists == 1:
        print("🔓 Login successful!\n")
        choice = input("Would you like to (1) Find a Match or (2) Update your Details? Enter 1 or 2: ")
        if choice == '1':
            find_match(username)
        elif choice == '2':
            update_details(username)
    else:
        print("❌ Incorrect username or password.\n")

def find_match(username):
    print("\n--- FINDING A MATCH ---")
    user_data = []

    with open(user_details_file, 'r', newline='') as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            if row[0] == username:
                user_data = row
                break

    if len(user_data) == 0:
        print("No details found for user.")
        return

    print("Choose criteria for finding a match:")
    print("1. By Age")
    print("2. By Interests")
    print("3. By Both Age and Interests")
    choice = input("Enter your choice (1-3): ")

    matches = []
    with open(user_details_file, 'r', newline='') as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            if row[0] != username and row[1] != user_data[1]:  
                user_age = int(user_data[2])
                match_age = int(row[2])
                user_interests = user_data[3].split(", ")
                match_interests = row[3].split(", ")
                
                age_difference = user_age - match_age
                if age_difference < 0:
                    age_difference = -age_difference

                common_interests = []
                for interest in user_interests:
                    if interest in match_interests:
                        common_interests.append(interest)

                if (choice == '1' and age_difference <= 5) or \
                   (choice == '2' and len(common_interests) > 0) or \
                   (choice == '3' and age_difference <= 5 and len(common_interests) > 0):
                    matches.append([row[0], match_age, match_interests])

    if len(matches) > 0:
        print("Available matches based on your criteria:")
        for index in range(len(matches)):
            match_username = matches[index][0]
            match_age = matches[index][1]
            match_interests = matches[index][2]
            print(f"{index + 1}. Username: {match_username}, Age: {match_age}, Interests: {', '.join(match_interests)}")
        
        match_choice = int(input("Select a match by entering the number: ")) - 1
        selected_match = matches[match_choice][0]
        print(f"\n💘 You selected {selected_match}. Running FLAMES game…")
        result = flames_game(username, selected_match)
        print(f"The FLAMES result between you and {selected_match} is: {result}\n")
    else:
        print("No suitable match found based on the chosen criteria.\n")

def admin_interface():
    print("\n--- ADMIN INTERFACE ---")
    admin_username = input("Enter admin username: ")
    admin_password = input("Enter admin password: ")

    admin_exists = 0
    with open(credentials_file, 'r', newline='') as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            if row[0] == admin_username and row[1] == admin_password:
                admin_exists = 1
                break

    if admin_exists == 1:
        print("✅ Admin login successful.")
        action = input("Do you want to (1) Add a User or (2) Remove a User? Enter 1 or 2: ")
        if action == '1':
            signup()
        elif action == '2':
            remove_user()
    else:
        print("❌ Invalid admin credentials.\n")

def remove_user():
    print("\n--- REMOVE USER ---")
    username = input("Enter the username to remove: ")

    user_found = 0
    rows_to_keep = []

    with open(credentials_file, 'r', newline='') as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            if row[0] == username:
                user_found = 1
            else:
                rows_to_keep.append(row)

    if user_found == 1:
        with open(credentials_file, 'w', newline='') as csvfile:
            writer = csv.writer(csvfile)
            writer.writerows(rows_to_keep)
    else:
        print(f"❌ User '{username}' does not exist in the records.\n")
        return

    rows_to_keep = []
    with open(user_details_file, 'r', newline='') as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            if row[0] != username:
                rows_to_keep.append(row)

    with open(user_details_file, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerows(rows_to_keep)
    print(f"✅ User '{username}' removed successfully from both files.\n")

def main():
    print("Welcome to the Matchmaking Service! 💖")
    while 1:
        print("\nChoose an option:")
        print("1. Signup")
        print("2. Login")
        print("3. Admin")
        print("4. Exit")
        choice = input("Enter your choice (1-4): ")

        if choice == "1":
            signup()
        elif choice == "2":
            login()
        elif choice == "3":
            admin_interface()
        elif choice == "4":
            print("Thank you for using the Matchmaking Service! Goodbye 👋")
            break
        else:
            print("Invalid choice. Please enter a number between 1 and 4.\n")

main()
