



1)

INSERT INTO INSTRUCTOR(INSTRUCTOR_ID, SALUTATION, first_name, last_name, street_address, zip, phone, 
CREATED_BY, CREATED_DATE, MODIFIED_BY, MODIFIED_date)
values(815, 'Mr', 'Hugo', 'Reyes', '2342 Oceanic Way', '07002', null, 'Burak', sysdate,'Burak', sysdate);

2)

INSERT INTO SECTION(section_id, course_no, section_no, start_date_time, location, instructor_id, capacity, created_by, 
created_date, modified_by, modified_date)
values(48, 142, 4, TO_DATE('22-SEP-11 8:15' , 'DD-MON-YY HH24:MI') , 'L211', 815, 15, 'Burak', 
sysdate, 'Burak', sysdate);

3)

INSERT INTO enrollment
    (student_id, section_id, enroll_date, final_grade, 
     created_by, created_date, modified_by, modified_date)
    (SELECT student_id, 48, sysdate, null, 'Burak', sysdate, 'Burak', sysdate
        FROM student
        WHERE student_id IN (375,137,266,382));
4)

DELETE FROM grade
where STUDENT_ID = 147 and SECTION_ID = 120;

DELETE FROM ENROLLMENT 
where STUDENT_ID = 147 and SECTION_ID = 120;

5)

DELETE FROM grade
where STUDENT_ID = 180 and SECTION_ID = 119;

DELETE FROM ENROLLMENT 
where STUDENT_ID = 180 and SECTION_ID = 119;


6)

UPDATE INSTRUCTOR
SET PHONE = 4815162342
WHERE INSTRUCTOR_ID = 815;

7)

UPDATE grade
set numeric_grade = 100
where section_id = 119
and grade_type_code = 'HM'
and GRADE_CODE_OCCURRENCE = 1;

8)

UPDATE GRADE
SET numeric_grade = (numeric_grade + (numeric_grade * .1))
WHERE SECTION_ID = 119 AND GRADE_TYPE_CODE = 'FI';

9)

SELECT lt.section_id, location, NVL(ENROLLED, 0) AS ENROLLED
FROM
(select s.section_id, location
from course c, section s
where s.COURSE_NO = c.COURSE_NO and c.DESCRIPTION like '%Project Management%'
group by s.section_id, location)lt
LEFT OUTER JOIN
(select s.section_id, count(*) as ENROLLED
FROM course c, section s, ENROLLMENT e
WHERE s.COURSE_NO = c.COURSE_NO and s.SECTION_ID = e.SECTION_ID and c.DESCRIPTION like '%Project Management%'
GROUP BY s.section_id)rt
ON lt.section_id = rt.section_id
ORDER BY lt.section_id;

10)

SELECT first_name, last_name, phone
FROM INSTRUCTOR i, section s, course c
WHERE s.INSTRUCTOR_ID = i.INSTRUCTOR_ID and s.COURSE_NO = c.COURSE_NO
AND c.DESCRIPTION like '%Project Management%'
ORDER BY last_name;

11)

SELECT DISTINCT s.student_id, first_name, last_name, to_char(avg(g.NUMERIC_GRADE), '99.99') as AVERAGE
FROM student s, ENROLLMENT e, grade g
WHERE s.STUDENT_ID = e.STUDENT_ID and g.SECTION_ID = e.SECTION_ID and g.STUDENT_ID = e.STUDENT_ID 
AND e.SECTION_ID = 119
GROUP BY s.student_id, first_name, last_name
ORDER BY s.student_id;

12)

SELECT count(*) as NUMBEROFINSTRUCTORS
FROM
    (select INSTRUCTOR_ID, count(student_id) as enrolled
    from section s, ENROLLMENT e
    where s.section_id = e.section_id and location = 'L211'
    group by INSTRUCTOR_ID)
WHERE enrolled > 3;

13)

SELECT SALUTATION || '.' || first_name ||' ' || last_name as INSTRUCTOR, phone
FROM INSTRUCTOR
WHERE INSTRUCTOR_id =

    (select lt.INSTRUCTOR_id
    from
        (select s.INSTRUCTOR_id
        from INSTRUCTOR i, section s, course c
        where s.INSTRUCTOR_ID = i.INSTRUCTOR_ID and s.COURSE_NO = c.COURSE_NO
        and c.DESCRIPTION like '%Project Management%' and c.course_no = 142) lt
    left outer join
        (select INSTRUCTOR_ID, count(*) as courses
        from section 
        group by INSTRUCTOR_ID) rt
    on lt.INSTRUCTOR_id = rt.INSTRUCTOR_id
    where courses = 1);



14)

SELECT first_name, last_name, rt.section_id, course_no
FROM
(select section_id, student_id
from ENROLLMENT left outer join grade
using ( student_id, section_id)
WHERE NUMERIC_GRADE is null)lt
left outer join
(select e.student_id, first_name, last_name, e.section_id, course_no
from student s, ENROLLMENT e, section t
where s.STUDENT_ID = e.STUDENT_ID and t.SECTION_ID = e.SECTION_ID)rt
on lt.student_id = rt.student_id and lt.section_id = rt.section_id;


15)

SELECT DISTINCT to_char(start_date_time, 'hh:mi AM') as STARTTIME,  count(DISTINCT course_no) as NUMBER_OF_COURSES
FROM section
GROUP BY to_char(start_date_time, 'hh:mi AM') 
ORDER BY STARTTIME;


ROLLBACK;




