import mysql.connector as con

def create_database():
    try:
        temp_con = con.connect(host="localhost", user="root", passwd="9423260212", port=3306)
        temp_cursor = temp_con.cursor()
        temp_cursor.execute("CREATE DATABASE IF NOT EXISTS doctor_appointments")
        temp_con.close()
    except Exception as e:
        print(f"Error creating database: {e}")

def connect_to_database():
    try:
        mycon = con.connect(
            host="localhost",
            user="root",
            passwd="9423260212",
            database="doctor_appointments"
        )
        return mycon
    except Exception as e:
        print(f"Error connecting to database: {e}")
        return None

def create_tables(cursor):
    cursor.execute('''CREATE TABLE IF NOT EXISTS Patients (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        name VARCHAR(255),
                        phone_number VARCHAR(20),
                        email VARCHAR(255))''')

def create_patient(cursor, name, phone, email):
    try:
        cursor.execute("INSERT INTO Patients (name, phone_number, email) VALUES (%s, %s, %s)", (name, phone, email))
        mycon.commit()
        print("Patient added successfully!")
    except Exception as e:
        print(f"Failed to add patient: {e}")

def view_patients(cursor):
    try:
        cursor.execute("SELECT * FROM Patients")
        patients = cursor.fetchall()
        for patient in patients:
            print(f"ID: {patient[0]} | Name: {patient[1]} | Phone: {patient[2]} | Email: {patient[3]}")
    except Exception as e:
        print(f"Failed to fetch patients: {e}")

def search_patient(cursor, patient_id):
    try:
        cursor.execute("SELECT * FROM Patients WHERE id=%s", (patient_id,))
        patient = cursor.fetchone()
        if patient:
            print(f"ID: {patient[0]} | Name: {patient[1]} | Phone: {patient[2]} | Email: {patient[3]}")
        else:
            print("Patient not found.")
    except Exception as e:
        print(f"Failed to search patient: {e}")

def update_patient(cursor, patient_id, name, phone, email):
    try:
        cursor.execute("UPDATE Patients SET name=%s, phone_number=%s, email=%s WHERE id=%s", (name, phone, email, patient_id))
        mycon.commit()
        if cursor.rowcount > 0:
            print("Patient updated successfully!")
        else:
            print("Patient not found.")
    except Exception as e:
        print(f"Failed to update patient: {e}")

def delete_patient(cursor, patient_id):
    try:
        cursor.execute("DELETE FROM Patients WHERE id=%s", (patient_id,))
        mycon.commit()
        if cursor.rowcount > 0:
            print("Patient deleted successfully!")
        else:
            print("Patient not found.")
    except Exception as e:
        print(f"Failed to delete patient: {e}")

def menu():
    while True:
        print("\nDoctor Appointment Management System")
        print("1. Add Patient")
        print("2. View Patients")
        print("3. Search Patient")
        print("4. Update Patient")
        print("5. Delete Patient")
        print("6. Exit")
        choice = input("Enter your choice: ")
        
        if choice == '1':
            name = input("Enter patient name: ")
            phone = input("Enter phone number: ")
            email = input("Enter email: ")
            create_patient(cursor, name, phone, email)
        elif choice == '2':
            view_patients(cursor)
        elif choice == '3':
            patient_id = input("Enter patient ID: ")
            search_patient(cursor, patient_id)
        elif choice == '4':
            patient_id = input("Enter patient ID: ")
            name = input("Enter new name: ")
            phone = input("Enter new phone number: ")
            email = input("Enter new email: ")
            update_patient(cursor, patient_id, name, phone, email)
        elif choice == '5':
            patient_id = input("Enter patient ID to delete: ")
            delete_patient(cursor, patient_id)
        elif choice == '6':
            print("Exiting...")
            break
        else:
            print("Invalid choice, please try again.")

# Initialize the database and tables
create_database()
mycon = connect_to_database()
cursor = mycon.cursor()
create_tables(cursor)

# Start the menu
menu()

# Close the connection
mycon.close()
