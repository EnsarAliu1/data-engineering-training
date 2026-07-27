students = [
    {"student_id": 1, "name": "Rijon", "city": "Vushtrri", "status": "active"},
    {"student_id": 2, "name": "Eljesa", "city": "Prishtina", "status": "active"},
    {"student_id": 3, "name": "Urim", "city": "Mitrovica", "status": "active"}
]


def update_student_city(student_id, new_city):
    for student in students:
        if student["student_id"] == student_id:
            student["city"] = new_city
            print("City updated successfully")


def update_student_status(student_id, new_status):
    for student in students:
        if student["student_id"] == student_id:
            student["status"] = new_status
            print("Status updated successfully")


def hard_delete_student(student_id):
    global students
    students = [
        student for student in students
        if student["student_id"] != student_id
    ]
    print("Student permanently deleted")


def soft_delete_student(student_id):
    for student in students:
        if student["student_id"] == student_id:
            student["status"] = "deleted"
            print("Student soft deleted")


def print_students():
    for student in students:
        print(student)


print("Initial students:")
print_students()


update_student_city(1, "Pristina")

update_student_status(2, "paused")

soft_delete_student(3)

hard_delete_student(2)


print("\nFinal students:")
print_students()


# ==========================================
# Explanation:
#
# 1. SQL UPDATE vs Python dictionary change:
# SQL UPDATE changes the value of a column in a database row.
# In Python, changing a dictionary value does the same thing.
#
# Example:
# SQL:
# UPDATE students SET city = 'Pristina' WHERE student_id = 1;
#
# Python:
# student["city"] = "Pristina"
#
#
# 2. SQL DELETE vs removing an item from a Python list:
# SQL DELETE removes a complete database row.
# In Python, removing an item from a list deletes that object.
#
# Example:
# SQL:
# DELETE FROM students WHERE student_id = 2;
#
# Python:
# students.remove(student)
#
#
# 3. Why soft delete is safer:
# Soft delete does not remove historical information.
# It only changes the status, for example from "active"
# to "deleted" or "cancelled".
#
# In training systems, attendance, scores, and submissions
# are important historical records, so keeping the data is safer
# than permanently deleting it.
# ==========================================
