

REM ********************************************************************
REM DỰNG KHUNG BẢNG (CREATE TABLES)
REM ********************************************************************

CREATE TABLE regions (
    region_id      NUMBER CONSTRAINT region_id_nn NOT NULL,
    region_name    VARCHAR2(25),
    CONSTRAINT reg_id_pk PRIMARY KEY (region_id)
);

CREATE TABLE countries (
    country_id      CHAR(2) CONSTRAINT country_id_nn NOT NULL,
    country_name    VARCHAR2(40),
    region_id       NUMBER,
    CONSTRAINT country_c_id_pk PRIMARY KEY (country_id)
);

ALTER TABLE countries ADD (
    CONSTRAINT countr_reg_fk FOREIGN KEY (region_id) REFERENCES regions(region_id)
);

CREATE TABLE locations (
    location_id    NUMBER(4),
    street_address VARCHAR2(40),
    postal_code    VARCHAR2(12),
    city           VARCHAR2(30) CONSTRAINT loc_city_nn NOT NULL,
    state_province VARCHAR2(25),
    country_id     CHAR(2),
    CONSTRAINT loc_id_pk PRIMARY KEY (location_id),
    CONSTRAINT loc_c_id_fk FOREIGN KEY (country_id) REFERENCES countries(country_id)
);

CREATE TABLE departments (
    department_id    NUMBER(4),
    department_name  VARCHAR2(30) CONSTRAINT dept_name_nn NOT NULL,
    manager_id       NUMBER(6),
    location_id      NUMBER(4),
    CONSTRAINT dept_id_pk PRIMARY KEY (department_id),
    CONSTRAINT dept_loc_fk FOREIGN KEY (location_id) REFERENCES locations (location_id)
);

CREATE TABLE jobs (
    job_id         VARCHAR2(10),
    job_title      VARCHAR2(35) CONSTRAINT job_title_nn NOT NULL,
    min_salary     NUMBER(6),
    max_salary     NUMBER(6),
    CONSTRAINT job_id_pk PRIMARY KEY (job_id)
);

CREATE TABLE employees (
    employee_id    NUMBER(6),
    first_name     VARCHAR2(20),
    last_name      VARCHAR2(25) CONSTRAINT emp_last_name_nn NOT NULL,
    email          VARCHAR2(25) CONSTRAINT emp_email_nn NOT NULL,
    phone_number   VARCHAR2(20),
    hire_date      DATE CONSTRAINT emp_hire_date_nn NOT NULL,
    job_id         VARCHAR2(10) CONSTRAINT emp_job_nn NOT NULL,
    salary         NUMBER(8,2),
    commission_pct NUMBER(2,2),
    manager_id     NUMBER(6),
    department_id  NUMBER(4),
    CONSTRAINT emp_salary_min CHECK (salary > 0),
    CONSTRAINT emp_email_uk UNIQUE (email),
    CONSTRAINT emp_emp_id_pk PRIMARY KEY (employee_id),
    CONSTRAINT emp_dept_fk FOREIGN KEY (department_id) REFERENCES departments,
    CONSTRAINT emp_job_fk FOREIGN KEY (job_id) REFERENCES jobs (job_id),
    CONSTRAINT emp_manager_fk FOREIGN KEY (manager_id) REFERENCES employees
);

ALTER TABLE departments ADD (
    CONSTRAINT dept_mgr_fk FOREIGN KEY (manager_id) REFERENCES employees (employee_id)
);

CREATE TABLE job_history (
    employee_id   NUMBER(6) CONSTRAINT jhist_employee_nn NOT NULL,
    start_date    DATE CONSTRAINT jhist_start_date_nn NOT NULL,
    end_date      DATE CONSTRAINT jhist_end_date_nn NOT NULL,
    job_id        VARCHAR2(10) CONSTRAINT jhist_job_nn NOT NULL,
    department_id NUMBER(4),
    CONSTRAINT jhist_date_interval CHECK (end_date > start_date),
    CONSTRAINT jhist_emp_id_st_date_pk PRIMARY KEY (employee_id, start_date),
    CONSTRAINT jhist_job_fk FOREIGN KEY (job_id) REFERENCES jobs,
    CONSTRAINT jhist_emp_fk FOREIGN KEY (employee_id) REFERENCES employees,
    CONSTRAINT jhist_dept_fk FOREIGN KEY (department_id) REFERENCES departments
);

CREATE OR REPLACE VIEW emp_details_view AS
SELECT e.employee_id, e.job_id, e.manager_id, e.department_id, d.location_id, l.country_id,
       e.first_name, e.last_name, e.salary, e.commission_pct, d.department_name, j.job_title,
       l.city, l.state_province, c.country_name, r.region_name
FROM employees e, departments d, jobs j, locations l, countries c, regions r
WHERE e.department_id = d.department_id AND d.location_id = l.location_id 
  AND l.country_id = c.country_id AND c.region_id = r.region_id AND j.job_id = e.job_id;

REM ********************************************************************
REM BƠM DỮ LIỆU MẪU (INSERT DATA / VALUE)
REM ********************************************************************

-- INSERTING into REGIONS
INSERT INTO regions VALUES (1, 'Europe');
INSERT INTO regions VALUES (2, 'Americas');
INSERT INTO regions VALUES (3, 'Asia');
INSERT INTO regions VALUES (4, 'Middle East and Africa');

-- INSERTING into COUNTRIES
INSERT INTO countries VALUES ('IT', 'Italy', 1);
INSERT INTO countries VALUES ('JP', 'Japan', 3);
INSERT INTO countries VALUES ('US', 'United States of America', 2);
INSERT INTO countries VALUES ('CA', 'Canada', 2);
INSERT INTO countries VALUES ('CN', 'China', 3);
INSERT INTO countries VALUES ('IN', 'India', 3);
INSERT INTO countries VALUES ('BR', 'Brazil', 2);
INSERT INTO countries VALUES ('UK', 'United Kingdom', 1);
INSERT INTO countries VALUES ('DE', 'Germany', 1);

-- INSERTING into LOCATIONS
INSERT INTO locations VALUES (1000, '1297 Via Cola di Rie', '00989', 'Roma', NULL, 'IT');
INSERT INTO locations VALUES (1100, '9450 Kamiya-cho', '6823', 'Hiroshima', NULL, 'JP');
INSERT INTO locations VALUES (1400, '2014 Jabberwocky Rd', '26192', 'Southlake', 'Texas', 'US');
INSERT INTO locations VALUES (1500, '2011 Interiors Blvd', '99236', 'South San Francisco', 'California', 'US');
INSERT INTO locations VALUES (1700, '2004 Charade Rd', '98199', 'Seattle', 'Washington', 'US');
INSERT INTO locations VALUES (1800, '147 Spadina Ave', 'M5V 2L7', 'Toronto', 'Ontario', 'CA');
INSERT INTO locations VALUES (2500, 'Magdalen Centre, The Oxford Science Park', 'OX9 9ZB', 'Oxford', 'Oxford', 'UK');

-- INSERTING into JOBS
INSERT INTO jobs VALUES ('AD_PRES', 'President', 20080, 40000);
INSERT INTO jobs VALUES ('AD_VP', 'Administration Vice President', 15000, 30000);
INSERT INTO jobs VALUES ('AD_ASST', 'Administration Assistant', 3000, 6000);
INSERT INTO jobs VALUES ('FI_MGR', 'Finance Manager', 8200, 16000);
INSERT INTO jobs VALUES ('FI_ACCOUNT', 'Accountant', 4200, 9000);
INSERT INTO jobs VALUES ('AC_MGR', 'Accounting Manager', 8200, 16000);
INSERT INTO jobs VALUES ('AC_ACCOUNT', 'Public Accountant', 4200, 9000);
INSERT INTO jobs VALUES ('SA_MAN', 'Sales Manager', 10000, 20080);
INSERT INTO jobs VALUES ('SA_REP', 'Sales Representative', 6000, 12008);
INSERT INTO jobs VALUES ('IT_PROG', 'Programmer', 4000, 10000);
INSERT INTO jobs VALUES ('ST_CLERK', 'Shipping Clerk', 2500, 5500);

-- ALTERING DEPARTMENTS TO TO AVOID FK CONSTRAINT BEFORE EMPLOYEES INSERT
ALTER TABLE departments DISABLE CONSTRAINT dept_mgr_fk;

-- INSERTING into DEPARTMENTS
INSERT INTO departments VALUES (10, 'Administration', 200, 1700);
INSERT INTO departments VALUES (20, 'Marketing', 201, 1800);
INSERT INTO departments VALUES (30, 'Purchasing', 114, 1700);
INSERT INTO departments VALUES (50, 'Shipping', 121, 1500);
INSERT INTO departments VALUES (60, 'IT', 103, 1400);
INSERT INTO departments VALUES (80, 'Sales', 145, 2500);
INSERT INTO departments VALUES (90, 'Executive', 100, 1700);
INSERT INTO departments VALUES (110, 'Accounting', 205, 1700);

-- INSERTING into EMPLOYEES (Có cấu trúc phân cấp quản lý Manager)
INSERT INTO employees VALUES (100, 'Steven', 'King', 'SKING', '515.123.4567', TO_DATE('17-06-2003', 'DD-MM-YYYY'), 'AD_PRES', 24000, NULL, NULL, 90);
INSERT INTO employees VALUES (101, 'Neena', 'Kochhar', 'NKOCHHAR', '515.123.4568', TO_DATE('21-09-2005', 'DD-MM-YYYY'), 'AD_VP', 17000, NULL, 100, 90);
INSERT INTO employees VALUES (102, 'Lex', 'De Haan', 'LDEHAAN', '515.123.4569', TO_DATE('13-01-2001', 'DD-MM-YYYY'), 'AD_VP', 17000, NULL, 100, 90);
INSERT INTO employees VALUES (103, 'Alexander', 'Hunold', 'AHUNOLD', '590.423.4567', TO_DATE('03-01-2006', 'DD-MM-YYYY'), 'IT_PROG', 9000, NULL, 102, 60);
INSERT INTO employees VALUES (104, 'Bruce', 'Ernst', 'BERNST', '590.423.4568', TO_DATE('21-05-2007', 'DD-MM-YYYY'), 'IT_PROG', 6000, NULL, 103, 60);
INSERT INTO employees VALUES (107, 'Diana', 'Lorentz', 'DLORENTZ', '590.423.4569', TO_DATE('07-02-2007', 'DD-MM-YYYY'), 'IT_PROG', 4200, NULL, 103, 60);
INSERT INTO employees VALUES (114, 'Den', 'Raphaely', 'DRAPHEAL', '515.124.4569', TO_DATE('07-12-2002', 'DD-MM-YYYY'), 'IT_PROG', 11000, NULL, 100, 30);
INSERT INTO employees VALUES (145, 'John', 'Russell', 'JRUSSEL', '011.44.1344.429268', TO_DATE('01-10-2004', 'DD-MM-YYYY'), 'SA_MAN', 14000, 0.4, 100, 80);
INSERT INTO employees VALUES (146, 'Karen', 'Partners', 'KPARTNER', '011.44.1344.467268', TO_DATE('05-01-2005', 'DD-MM-YYYY'), 'SA_MAN', 13500, 0.3, 100, 80);
INSERT INTO employees VALUES (176, 'Jonathon', 'Taylor', 'JTAYLOR', '011.44.1644.429265', TO_DATE('24-03-2006', 'DD-MM-YYYY'), 'SA_REP', 8600, 0.2, 146, 80);
INSERT INTO employees VALUES (200, 'Jennifer', 'Whalen', 'JWHALEN', '515.123.4444', TO_DATE('17-09-2003', 'DD-MM-YYYY'), 'AD_ASST', 4400, NULL, 101, 10);
INSERT INTO employees VALUES (201, 'Michael', 'Hartstein', 'MHARTSTE', '515.123.5555', TO_DATE('17-02-2004', 'DD-MM-YYYY'), 'MK_MAN', 13000, NULL, 100, 20);
INSERT INTO employees VALUES (205, 'Shelley', 'Higgins', 'SHIGGINS', '515.123.8080', TO_DATE('07-06-2002', 'DD-MM-YYYY'), 'AC_MGR', 12008, NULL, 101, 110);
INSERT INTO employees VALUES (206, 'William', 'Gietz', 'WGIETZ', '515.123.8181', TO_DATE('07-06-2002', 'DD-MM-YYYY'), 'AC_ACCOUNT', 8300, NULL, 205, 110);


-- ENABLE BACK DEPARTMENTS FK CONSTRAINT
ALTER TABLE departments ENABLE CONSTRAINT dept_mgr_fk;

-- INSERTING into JOB_HISTORY
INSERT INTO job_history VALUES (102, TO_DATE('13-01-2001', 'DD-MM-YYYY'), TO_DATE('24-07-2006', 'DD-MM-YYYY'), 'IT_PROG', 60);
INSERT INTO job_history VALUES (101, TO_DATE('28-10-2001', 'DD-MM-YYYY'), TO_DATE('29-11-2004', 'DD-MM-YYYY'), 'AC_ACCOUNT', 110);
INSERT INTO job_history VALUES (201, TO_DATE('17-02-2004', 'DD-MM-YYYY'), TO_DATE('19-12-2007', 'DD-MM-YYYY'), 'MK_REP', 20);
INSERT INTO job_history VALUES (114, TO_DATE('24-03-2006', 'DD-MM-YYYY'), TO_DATE('31-12-2007', 'DD-MM-YYYY'), 'ST_CLERK', 50);

COMMIT;

select * from employees;