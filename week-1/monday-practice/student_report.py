from moday_practice import students, students_by_city, students_by_course, students_with_low_attendance, total_students, average_attendance, homework_average, report_list

print("Student Report")

print()

print(f"Total Students: {total_students()}")

print(f"Average attendance: {average_attendance()}")

print(f"Average homework score: {homework_average()}")


print()

print("Students by city:")
students_by_city()

print()

print("Students by course:")
students_by_course()

print()

print("Students with low attendance: ")
students_with_low_attendance()

print()

print("Strong students: ")
for student in report_list:
    if student["performance_status"] == "Strong":
        print(f"{student['name']}")

print()

print("Students that need support: ")
for student in report_list:
    if student["performance_status"] == "Needs Support":
        print(f"{student['name']}")
