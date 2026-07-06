students = [
    {
        "id": 1,
        "name": "Arta",
        "city": "Vushtrri",
        "course": "Python",
        "age": 17,
        "attendance": 90,
        "homework": 85,
    },
    {
        "id": 2,
        "name": "Blend",
        "city": "Prishtina",
        "course": "React",
        "age": 18,
        "attendance": 60,
        "homework": 70,
    },
    {
        "id": 3,
        "name": "Dion",
        "city": "Vushtrri",
        "course": "Python",
        "age": 16,
        "attendance": 75,
        "homework": 95,
    },
    {
        "id": 4,
        "name": "Elira",
        "city": "Mitrovica",
        "course": "React",
        "age": 17,
        "attendance": 80,
        "homework": 60,
    },
    {
        "id": 5,
        "name": "Faton",
        "city": "Vushtrri",
        "course": "Data Engineering",
        "age": 19,
        "attendance": 100,
        "homework": 90,
    },
    {
        "id": 6,
        "name": "Gresa",
        "city": "Prishtina",
        "course": "Python",
        "age": 18,
        "attendance": 55,
        "homework": 88
    },
    {
        "id": 7,
        "name": "Albert",
        "city": "Skenderaj",
        "course": "Data Engineering",
        "age": 20,
        "attendance": 85,
        "homework": 75
    }
]

print("Detyra 1:")

print()


def total_students():
    number_of_students = len(students)
    return number_of_students


print(f"Total students: {total_students()}")

print()

print("Student names:")
for student in students:
    print(student["name"])

print()

print("Student details: ")
for student in students:
    print(
        f"{student['name']} is from {student['city']} and is learning {student['course']}.")

print()
######################################################################################################

print("Detyra 2:")

print()

print("Students from Vushtrri:")
for student in students:
    if student["city"] == "Vushtrri":
        print(f"{student['name']}")

print()

print("Students with low attendance:")


def students_with_low_attendance():
    for student in students:
        if student["attendance"] < 70:
            print(f"{student['name']}")


students_with_low_attendance()

print()

print("Students with homework score above 85:")
for student in students:
    if student["homework"] > 85:
        print(f"{student['name']}")

print()
###################################################################

print("Detyra 3:")

print()


def average_attendance():
    total_attendance = sum(student["attendance"] for student in students)
    average_attendance = total_attendance / len(students)
    return round(average_attendance, 2)


print(f"Average attendance: {average_attendance()}")

print()


def homework_average():
    total_homework_score = sum(student["homework"] for student in students)
    average_homework_score = total_homework_score / len(students)
    return round(average_homework_score, 2)


print(f"Average homework score: {homework_average()}")

print()

print("Students by city:")


def students_by_city():
    vushtrri = []
    prishtina = []
    mitrovica = []

    for student in students:
        if student["city"] == "Vushtrri":
            vushtrri.append(student)
        elif student["city"] == "Prishtina":
            prishtina.append(student)
        elif student["city"] == "Mitrovica":
            mitrovica.append(student)

    print(f"Vushtrri: {len(vushtrri)} ")
    print(f"Prishtina: {len(prishtina)}")
    print(f"Mitrovica: {len(mitrovica)}")


students_by_city()

print()


def students_by_course():
    print("Students by course:")
    python = []
    react = []
    data_engineering = []

    for student in students:
        if student["course"] == "Python":
            python.append(student)
        elif student["course"] == "React":
            react.append(student)
        elif student["course"] == "Data Engineering":
            data_engineering.append(student)

    print(f"Python: {len(python)} ")
    print(f"React: {len(react)}")
    print(f"Data Engineering: {len(data_engineering)}")


students_by_course()
print()
#######################################################################################################


print("Detyra 4:")

print()

print("Performance status:")
for student in students:
    if student["attendance"] >= 80 and student["homework"] >= 80:
        print(f"{student["name"]}: Strong")
    elif student["attendance"] >= 60 and student["homework"] >= 60:
        print(f"{student["name"]}: Average")
    else:
        print(f"{student["name"]}: Needs Support")

print()
########################################################################################################

print("Detyra 5:")

print()

report_list = []

for student in students:
    if student["attendance"] >= 80 and student["homework"] >= 80:
        performance_status = "Strong"
    elif student["attendance"] >= 60 and student["homework"] >= 60:
        performance_status = "Average"
    else:
        performance_status = "Needs Support"

    report_list.append({
        "student_id": student["id"],
        "name": student["name"],
        "course": student["course"],
        "performance_status": performance_status
    })
    print(f"{student['name']} - {student['course']} - {performance_status}")

print()
########################################################################################################

print("Bonus Task:")

print("Studented te renditur sipas score te detyrave te shtepise:")


def get_homework(student):
    return student["homework"]


students.sort(key=get_homework, reverse=True)

for student in students:
    print(f"{student['name']} - {student['homework']}")

print()

print("Top 3 studented me te dalluar sipas detyrave te shtepise dhe pjesmarrjes:")


def get_performance_score(student):
    return student["homework"] + student["attendance"]


students.sort(key=get_performance_score, reverse=True)

for student in students[:3]:
    print(
        f"{student['name']} - {student['homework']} - {student['attendance']}")


print()

print("Kontrolli nese lista eshte bosh programi te mos prishet")
if not students:
    print("Lista e studentëve është bosh.")

print()
print()
print()
