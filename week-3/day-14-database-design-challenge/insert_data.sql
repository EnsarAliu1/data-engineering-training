-- Part 3 - Insert Realistic Test Data

PRAGMA foreign_keys = ON;

INSERT INTO instructors (instructor_fullName, specialization) VALUES
    ('Artan Krasniqi',   'Web Development'),
    ('Rina Berisha',     'Data Science'),
    ('Gent Hoxha',       'Cybersecurity');

INSERT INTO students (student_fullName, student_email, student_city) VALUES
    ('Aldi Mehmeti',       'aldi.mehmeti@email.com',       'Prishtine'),
    ('Besa Gashi',         'besa.gashi@email.com',         'Prizren'),
    ('Drin Osmani',        'drin.osmani@email.com',        'Gjakove'),
    ('Fjolla Halili',      'fjolla.halili@email.com',      'Mitrovice'),
    ('Gresa Limani',       'gresa.limani@email.com',       'Peje'),
    ('Hana Morina',        'hana.morina@email.com',        'Ferizaj'),
    ('Ilir Sejdiu',        'ilir.sejdiu@email.com',        'Prishtine'),
    ('Jeta Bytyqi',        'jeta.bytyqi@email.com',        'Gjilan'),
    ('Kushtrim Rama',      'kushtrim.rama@email.com',      'Prizren'),
    ('Lirije Demolli',     'lirije.demolli@email.com',     'Prishtine'),
    ('Mentor Shala',  'mentor.shala@email.com',  'Peje'),
    ('Dea Kelmendi',  'dea.kelmendi@email.com',  'Gjakove');

INSERT INTO programs (program_name, instructor_id, level, price) VALUES
    ('HTML & CSS Fundamentals',   1, 'Beginner',     49.99),   
    ('JavaScript Advanced',       1, 'Advanced',    149.99),   
    ('Python for Data Science',   2, 'Intermediate', 99.99),   
    ('Network Security Basics',   3, 'Beginner',     79.99),   
    ('Ethical Hacking',           3, 'Advanced',    199.99);   

INSERT INTO enrollments (student_id, program_id, enrollment_date, status) VALUES
    (1,  1, '2025-01-10', 'completed'),   
    (2,  1, '2025-01-11', 'completed'),   
    (3,  1, '2025-01-12', 'active'),      
    (4,  1, '2025-01-13', 'active'),      
    (5,  1, '2025-01-14', 'dropped'),      
    (6,  1, '2025-01-15', 'active'),      
    (1,  2, '2025-02-01', 'active'),      
    (7,  2, '2025-02-03', 'active'),      
    (8,  2, '2025-02-05', 'dropped'),     
    (9,  3, '2025-03-01', 'active'),      
    (10, 3, '2025-03-02', 'completed'),   
    (2,  3, '2025-03-05', 'active'),      
    (3,  4, '2025-04-01', 'active'),      
    (5,  4, '2025-04-03', 'active'),      
    (7,  4, '2025-04-10', 'active');      

INSERT INTO attendance (enrollment_id, session_date, attended, minutes_attended) VALUES
    (1, '2025-01-15', 1, 90),
    (1, '2025-01-22', 1, 90),
    (1, '2025-01-29', 1, 85),
    (1, '2025-02-05', 1, 90),
    (1, '2025-02-12', 1, 90);

INSERT INTO attendance (enrollment_id, session_date, attended, minutes_attended) VALUES
    (2, '2025-01-15', 1, 88),
    (2, '2025-01-22', 1, 90),
    (2, '2025-01-29', 0,  0),
    (2, '2025-02-05', 1, 90),
    (2, '2025-02-12', 1, 75);

INSERT INTO attendance (enrollment_id, session_date, attended, minutes_attended) VALUES
    (3, '2025-01-15', 1, 90),
    (3, '2025-01-22', 0,  0),
    (3, '2025-01-29', 1, 60),
    (3, '2025-02-05', 0,  0);

INSERT INTO attendance (enrollment_id, session_date, attended, minutes_attended) VALUES
    (5, '2025-01-15', 1, 45),
    (5, '2025-01-22', 0,  0),
    (5, '2025-01-29', 0,  0);

INSERT INTO attendance (enrollment_id, session_date, attended, minutes_attended) VALUES
    (7, '2025-02-08', 1, 120),
    (7, '2025-02-15', 1, 120),
    (7, '2025-02-22', 1, 115),
    (7, '2025-03-01', 1, 120);

INSERT INTO attendance (enrollment_id, session_date, attended, minutes_attended) VALUES
    (9, '2025-02-08', 0,  0),
    (9, '2025-02-15', 1, 30);

INSERT INTO attendance (enrollment_id, session_date, attended, minutes_attended) VALUES
    (10, '2025-03-05', 1, 100),
    (10, '2025-03-12', 1, 100),
    (10, '2025-03-19', 1,  95),
    (10, '2025-03-26', 1, 100);

INSERT INTO attendance (enrollment_id, session_date, attended, minutes_attended) VALUES
    (11, '2025-03-05', 1, 100),
    (11, '2025-03-12', 1,  98),
    (11, '2025-03-19', 1, 100),
    (11, '2025-03-26', 1, 100);

INSERT INTO attendance (enrollment_id, session_date, attended, minutes_attended) VALUES
    (13, '2025-04-07', 1, 80),
    (13, '2025-04-14', 0,  0),
    (13, '2025-04-21', 1, 75);

INSERT INTO attendance (enrollment_id, session_date, attended, minutes_attended) VALUES
    (15, '2025-04-07', 1, 90),
    (15, '2025-04-14', 1, 85),
    (15, '2025-04-21', 0,  0);


INSERT INTO payments (enrollment_id, payment_date, payment_method, status) VALUES
    (1,  '2025-01-10', 'Card',          'Paid'),       
    (2,  '2025-01-11', 'Bank Transfer', 'Paid'),       
    (3,  '2025-01-12', 'Cash',          'Paid'),       
    (4,  '2025-01-13', 'Card',          'Pending'),   
    (5,  '2025-01-20', 'Cash',          'Refunded'),   
    (7,  '2025-02-01', 'Card',          'Paid'),       
    (8,  '2025-02-03', 'Bank Transfer', 'Paid'),       
    (9,  '2025-02-05', 'Card',          'Refunded'),   
    (10, '2025-03-01', 'Bank Transfer', 'Paid'),       
    (11, '2025-03-02', 'Card',          'Paid'),       
    (12, '2025-03-05', 'Cash',          'Pending'),    
    (13, '2025-04-01', 'Card',          'Paid'),       
    (14, '2025-04-03', 'Bank Transfer', 'Pending'),    
    (15, '2025-04-10', 'Cash',          'Paid'),       
    (12, '2025-03-10', 'Card',          'Paid');       