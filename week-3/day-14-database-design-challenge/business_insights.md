# Part 9 - Business Insights

## 37. Which program has the most active students?
**Results:** HTML & CSS Fundamentals (3 active students) and Network Security Basics (3 active students) are tied for the highest number of active students. JavaScript Advanced and Python for Data Science follow with 2 active students each. Ethical Hacking currently has 0 enrollments.

**Management Takeaway:** Entry-level web development and security courses drive our highest initial enrollment volume. Management should focus on keeping these foundational pipelines strong while finding ways to activate unutilized courses like Ethical Hacking.

---

## 38. Which program generated the most collected revenue?
**Results:** JavaScript Advanced generated the most collected revenue (€299.98), closely followed by Python for Data Science (€299.97). Network Security Basics brought in €159.98, and HTML & CSS Fundamentals collected €149.97.

**Management Takeaway:** Higher-priced intermediate and advanced programs generate double the revenue of beginner courses despite having fewer active students. Management should upsell students completing basic courses into these higher-margin programs rather than relying only on new student acquisition.

---

## 39. Which city has the most students?
**Results:** Prishtinë has the most students (3 students, 25% of total). Prizren, Pejë, and Gjakovë have 2 students each, while Mitrovicë, Gjilan, and Ferizaj have 1 student each.

**Management Takeaway:** Prishtinë is our main hub, but regional cities combined account for 50% of our student base. Any expansion or in-person events should center in Prishtinë, while maintaining robust online delivery for regional students.

---

## 40. Which students are financially risky?
**Results:** 
- Fjolla Halili (HTML & CSS): Pending payment (€49.99)
- Hana Morina (HTML & CSS): Missing payment record (€49.99)
- Besa Gashi (Python for Data Science): Pending payment (€99.99)
- Gresa Limani (Network Security Basics): Pending payment (€79.99)

**Management Takeaway:** We have €279.96 in outstanding revenue across 4 active students who are currently attending class without verified payment. Management should enforce automated system rules to lock course materials if payment isn't cleared within 7 days.

---

## 41. Which students are academically risky?
**Results:** 
- High Risk (0 attendance logged): Fjolla Halili, Hana Morina, Ilir Sejdiu, Besa Gashi, and Gresa Limani.
- Moderate Risk (< 70% attendance): Drin Osmani (50% in HTML & CSS, 66.7% in Network Security) and Ilir Sejdiu (66.7% in Network Security).

**Management Takeaway:** Students with zero or low attendance are at high risk of dropping out. Notably, Fjolla and Hana overlap as both financially and academically risky, pointing to ghost enrollments. The academic team needs automated alerts when a student misses two consecutive sessions to intervene early.

---

## 42. Which program has the weakest attendance?
**Results:** Network Security Basics has the weakest attendance rate at 66.67% (averaging 55 minutes per session), followed by HTML & CSS Fundamentals at 70.59%. In contrast, Python for Data Science leads with a 100% attendance rate.

**Management Takeaway:** Network Security Basics is struggling with retention and engagement. Management should review session timing, pace, and difficulty with instructor Gent Hoxha to improve student participation.

---

## 43. Which enrollments are missing payment records?
**Results:** Enrollment ID 6 (Hana Morina in HTML & CSS Fundamentals) is missing a payment record completely.

**Management Takeaway:** This reveals a workflow gap where an enrollment was processed without creating a corresponding payment entry. Financial admin must add the missing payment, and software engineering should enforce transactional integrity so enrollments and payments are created together.

---

## 44. Which instructor has the highest number of active students?
**Results:** Artan Krasniqi has the highest number of active students (5 active students across HTML & CSS and JavaScript Advanced). Gent Hoxha follows with 3, and Rina Berisha has 2.

**Management Takeaway:** Artan handles 50% of the active student body, creating a key-person dependency. If enrollment grows, management needs to hire a secondary web development instructor or TA to prevent overload.

---

## 45. What should management focus on next?
1. Enforce strict payment gatekeeping to collect the €279.96 in pending/missing fees.
2. Build an automated attendance alert system to catch at-risk students before they drop out.
3. Audit Network Security Basics to improve its 66.67% attendance rate.
4. Set up upselling pathways from HTML & CSS into higher-margin courses like JavaScript and Python.
5. Hire support staff for web development to balance Artan Krasniqi's workload.

---

## 46. What did your database design make easy, and what was difficult?
**What Was Easy:**
- Joining normalized tables to aggregate revenue, city distributions, and student counts using clear Foreign Keys.
- Enforcing status values using `CHECK` constraints to keep data clean.
- Finding administrative gaps like missing payments using `LEFT JOIN ... WHERE payment_id IS NULL`.

**What Was Difficult:**
- Calculating attendance percentages across multi-level joins (`students` -> `enrollments` -> `attendance`) when students had zero attendance records.
- Handling revenue logic when price is stored in `programs` but status lives in `payments`.
- Realizing that basic DDL foreign keys cannot enforce business rules, such as requiring a payment record at the exact moment of enrollment.
