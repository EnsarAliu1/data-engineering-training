import csv
from pathlib import Path

file_path = Path(__file__).parent / "data" / "students_raw.csv"


# Task 1 and 2 ###################################################################
def print_columns():
    with file_path.open("r", encoding="utf-8", newline="") as f:
        rows = list(csv.reader(f))
        if rows:
            print("Columns:")
            print(", ".join(rows[0]))


print("CSV Inspection")
print()
with file_path.open("r", encoding="utf-8", newline="") as f:
    rows = list(csv.reader(f))
    print(f"Total raw records: {len(rows) - 1}")

print()
print_columns()

print()

print("First 3 records:")
for student in rows[1:4]:
    print(f"{student[0]} - {student[1]} - {student[3]}")

# End of Task 1 and 2 ###############################################################

print()

# Task 3 ##########################################################################

print("Data Quality Report")

print()

total_issues_found = 0

missing_values = []

invalid_numeric_values = []

inconsistent_text_values = []

# Kolonat: student_id(0), name(1), city(2), course(3), age(4), attendance(5), homework_score(6), registered_date(7)

for i in range(len(rows[0])):
    for row in rows[1:]:
        val = row[i].strip()

        if val == "":
            total_issues_found += 1

        elif i == 1 and val != val.title():
            total_issues_found += 1
            inconsistent_text_values.append((row[0], rows[0][i]))
        elif i == 2 and val != val.title():
            total_issues_found += 1
            inconsistent_text_values.append((row[0], rows[0][i]))

        elif i == 3 and val != val.title():
            total_issues_found += 1
            inconsistent_text_values.append((row[0], rows[0][i]))

        elif i == 4 and not val.isdigit():
            total_issues_found += 1
            invalid_numeric_values.append((row[0], rows[0][i]))

        elif i == 5 and not val.isdigit():
            total_issues_found += 1
            invalid_numeric_values.append((row[0], rows[0][i]))

        elif i == 6 and not val.isdigit():
            total_issues_found += 1
            invalid_numeric_values.append((row[0], rows[0][i]))

        elif i == 7 and len(val.split("-")) != 3:
            total_issues_found += 1

print(f"Total issues found: {total_issues_found}")

print()


print("Missing values:")
for student_id, column in missing_values:
    print(f"student_id = {student_id}, column = {column}")


print()


print("Invalid numeric values:")
for student_id, column in invalid_numeric_values:
    print(
        f"student_id = {student_id}, column = {column}, value = {rows[int(student_id)][rows[0].index(column)]}")


print()

print("Inconsistent text values:")
for student_id, column in inconsistent_text_values:
    print(
        f"student_id = {student_id}, column = {column}, value = {rows[int(student_id)][rows[0].index(column)]}")

# End of Task 3 ##########################################################################

print()

# Task 4 , 5 ###########################################################################


# Kolonat: student_id(0), name(1), city(2), course(3), age(4), attendance(5), homework_score(6), registered_date(7)

students_clean = []

for row in rows[1:]:
    cleaned_row = []

    for i, val in enumerate(row):
        val = val.strip()

        if i == 2:  # city
            if val == "" or val == val.lower() or val == val.upper():
                val = "Unknown"
            else:
                val = val.title()

        elif i == 3:  # course
            if val == "":
                val = "Not Assigned"
            else:
                val = val.title()

        elif i == 4 or i == 5 or i == 6:  # age, attendance, homework_score
            if not val.isdigit():
                val = 0

        elif i == 7:  # registered_date
            if val == "":
                val = "Unknown Date"

        cleaned_row.append(val)

    students_clean.append(cleaned_row)


for row in students_clean:
    row[0] = int(row[0])
    row[4] = int(row[4])
    row[5] = int(row[5])
    row[6] = int(row[6])


for row in students_clean:
    total_score = row[5] + row[6]
    row.append(total_score)


for row in students_clean:
    if row[5] >= 80 and row[6] >= 80:
        performance_status = "Strong"
    elif row[5] >= 60 and row[6] >= 60:
        performance_status = "Average"
    else:
        performance_status = "Needs Support"

    row.append(performance_status)

for row in students_clean:
    if row[5] < 60 or row[6] < 60:
        risk_flag = "At Risk"
    else:
        risk_flag = "OK"

    row.append(risk_flag)


print()

print("Performance Status")

print()

for row in students_clean:
    name = row[1]
    performance_status = row[9]
    risk_flag = row[10]
    print(f"{name}: {performance_status} - {risk_flag}")

# End of  Task 4 , 5 ###########################################################################


print()

# Task 6 ###########################################################################

output_path = Path(__file__).parent / "output" / "students_clean.csv"
output_path.parent.mkdir(parents=True, exist_ok=True)

header = [
    "student_id", "name", "city", "course", "age",
    "attendance", "homework_score", "registered_date",
    "total_score", "performance_status", "risk_flag"
]

with output_path.open("w", encoding="utf-8", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(header)
    writer.writerows(students_clean)

print(f"Cleaned CSV saved to: {output_path}")
print(f"Total records saved: {len(students_clean)}")

# End of Task 6 ###################################################################

# Task 7 ###########################################################################

avg_attendance = sum(row[5] for row in students_clean) / len(students_clean)
avg_homework = sum(row[6] for row in students_clean) / len(students_clean)

city_counts = {}
for row in students_clean:
    city = row[2]
    city_counts[city] = city_counts.get(city, 0) + 1

course_counts = {}
for row in students_clean:
    course = row[3]
    course_counts[course] = course_counts.get(course, 0) + 1

strong_students = [row[1] for row in students_clean if row[9] == "Strong"]
support_students = [row[1]
                    for row in students_clean if row[9] == "Needs Support"]
at_risk_students = [row[1] for row in students_clean if row[10] == "At Risk"]

top3 = sorted(students_clean, key=lambda r: r[8], reverse=True)[:3]

report_lines = []
report_lines.append("Final Student Data Report")
report_lines.append(f"Total raw records: {len(rows) - 1}")
report_lines.append(f"Total cleaned records: {len(students_clean)}")
report_lines.append(f"Total data quality issues found: {total_issues_found}")
report_lines.append(f"Average attendance: {avg_attendance:.2f}")
report_lines.append(f"Average homework score: {avg_homework:.2f}")

report_lines.append("Students by city:")
for city, count in sorted(city_counts.items(), key=lambda x: x[1], reverse=True):
    report_lines.append(f"  {city}: {count}")

report_lines.append("Students by course:")
for course, count in sorted(course_counts.items(), key=lambda x: x[1], reverse=True):
    report_lines.append(f"  {course}: {count}")

report_lines.append("Strong students:")
for name in strong_students:
    report_lines.append(f"  {name}")

report_lines.append("Students that need support:")
for name in support_students:
    report_lines.append(f"  {name}")

report_lines.append("At Risk students:")
for name in at_risk_students:
    report_lines.append(f"  {name}")

report_lines.append("Top 3 students by total score:")
for row in top3:
    report_lines.append(f"  {row[1]}: {row[8]}")

print()
for line in report_lines:
    print(line)

report_path = Path(__file__).parent / "output" / "summary_report.txt"
with report_path.open("w", encoding="utf-8") as f:
    f.write("\n".join(report_lines) + "\n")

print()
print(f"Summary report saved to: {report_path}")

# End of Task 7 ###################################################################
